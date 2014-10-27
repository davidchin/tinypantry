class Recipe < ActiveRecord::Base
  include PgSearch
  include Cacheable
  include Remotable

  extend FriendlyId

  has_attached_file :image, styles: { thumb: '160x160#',
                                      small: '308x308#',
                                      medium: '640x640#',
                                      large: '860x860#' }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

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
    image.styles.keys.each_with_object({}) do |key, result|
      result[key] = image.url(key)
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
end
