class Recipe < ActiveRecord::Base
  include PgSearch

  extend FriendlyId

  has_attached_file :image, styles: { thumb: '100x100>' }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  before_create :ensure_image_size
  after_create :categorise

  belongs_to :feed

  has_many :categorisations, as: :keywordable, dependent: :destroy
  has_many :keywords, through: :categorisations
  has_many :categories,
           -> { group('categories.id').order('count(categories.id) desc') },
           through: :keywords

  has_many :related_recipes,
           -> (recipe) { where.not(id: recipe.id) },
           through: :keywords,
           source: :recipes

  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_users, through: :bookmarks, source: :user

  scope :recent, -> (time_ago = 7.days.ago) { where('created_at >= ?', time_ago) }
  scope :popular, -> { order(bookmarks_count: :desc, created_at: :desc) }
  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where.not(approved: true) }
  scope :by_category, -> (category) { joins(:categories).where('categories.slug = ?', category) }

  pg_search_scope :search_content,
                  against: {
                    name: 'A',
                    description: 'B'
                  },
                  using: {
                    tsearch: {
                      dictionary: 'english'
                    }
                  }

  friendly_id :slug_candidates, use: :slugged

  def remote_image_url=(url)
    url = URI.encode(url) if url.present?
    self.image = URI.parse(url)
    super

    rescue URI::Error
      false
  end

  def categorise
    new_keywords = matched_keywords - keywords

    transaction do
      new_keywords.each do |keyword|
        categorisations.create(keyword: keyword)
      end
    end
  end

  def image_urls
    image.styles.each_with_object(original: image.url) do |(key, style), result|
      result[key] = style.attachment.url
    end
  end

  private

  def matched_keywords
    name_matcher = FuzzyMatch.new(Keyword.all, read: :name, threshold: 0.25)
    desc_matcher = FuzzyMatch.new(Keyword.all, read: :name, threshold: 0.1)

    (name_matcher.find_all(name) + desc_matcher.find_all(description)).uniq
  end

  def slug_candidates
    [
      :name,
      [:name, -> { feed.name }]
    ]
  end

  def ensure_image_size
    min_size = 500 * 500

    return if FastImage.size(remote_image_url).reduce(:*) >= min_size

    file_name = File.basename(remote_image_url, '.*')
    doc = Nokogiri::HTML(open(url))

    # Grab all img urls
    srcs = doc.xpath('.//img/@src').map(&:value).unshift(remote_image_url)

    # Look for the largest img
    srcs.sort_by do |src|
      size = FastImage.size(src).reduce(:*)
      size * 2 if size >= min_size && src.include?(file_name)
    end.reverse!

    # Set remote image url
    self.remote_image_url = srcs.first if srcs.any?
  end
end
