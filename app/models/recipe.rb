class Recipe < ActiveRecord::Base
  include PgSearch
  include Cacheable

  extend FriendlyId

  MIN_REMOTE_IMAGE_SIZE = 500 * 500

  has_attached_file :image, styles: { thumb: '100x100>' }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  before_create :ensure_remote_image_size
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

  has_many :visits, as: :visitable

  scope :recent, -> (time_ago = 7.days.ago) { where('created_at >= ?', time_ago) }

  scope :most_recent, -> { order(created_at: :desc) }
  scope :most_bookmarked, -> { order(bookmarks_count: :desc, created_at: :desc) }
  scope :most_viewed, -> { includes(:visits).order('visits.total_count DESC NULLS LAST, recipes.created_at DESC') }

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

  def self.order_by(key = 'date')
    case key
    when 'bookmark'
      most_bookmarked
    when 'view'
      most_viewed
    else
      most_recent
    end
  end

  def remote_image_url=(url)
    if remote_image_url != url && url.present?
      self.image = URI.parse(URI.encode(url))
    end

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

  def remote_page
    @remote_page ||= Nokogiri::HTML(open(url))
  end

  def remote_image_area(url)
    FastImage.size(url).try(:reduce, :*) || 0
  end

  def remote_image_file_size(url)
    response = Net::HTTP.get_response(URI(url))
    response['content-length'].to_i || 0

    rescue StandardError
      0
  end

  def remote_image_srcs
    return @remote_image_srcs if @remote_image_srcs

    xpaths = [
      '//article//img/@src',
      '//*[@itemtype="http://schema.org/BlogPosting"]//img/@src',
      '//h1/ancestor::section//img/@src',
      '//img/@src'
    ]

    srcs = []
    xpaths.each do |xpath|
      srcs.concat(remote_page.xpath(xpath))
      break if srcs.length > 0
    end

    @remote_image_srcs = srcs.map do |src|
      URI.join(url, src.value).to_s
    end
  end

  def sorted_remote_image_srcs
    @sorted_remote_image_srcs ||= remote_image_srcs.sort_by do |src|
      remote_image_area(src) + remote_image_file_size(src)
    end.reverse
  end

  def ensure_remote_image_size
    return if remote_image_area(remote_image_url) >= MIN_REMOTE_IMAGE_SIZE

    self.remote_image_url = sorted_remote_image_srcs.first
  end
end
