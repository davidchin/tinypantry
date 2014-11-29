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
  after_save :update_counter

  belongs_to :feed

  has_many :categorisations, as: :keywordable, dependent: :destroy
  has_many :keywords, through: :categorisations
  has_many :categories,
           -> { group('categories.id').order('count(categories.id) desc') },
           through: :keywords

  has_many :related_recipes,
           -> (recipe) { where.not(id: recipe.id).uniq },
           through: :keywords,
           source: :recipes

  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_users, through: :bookmarks, source: :user

  has_one :visit, as: :visitable

  scope :recent, -> (time_ago = 7.days.ago) { where('published_at >= ?', time_ago) }

  scope :most_recent, -> { order(published_at: :desc) }
  scope :most_bookmarked, -> { order(bookmarks_count: :desc, published_at: :desc) }
  scope :most_viewed, -> { includes(:visit).order('visits.total_count DESC NULLS LAST, recipes.published_at DESC') }

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

  def self.categorise_all
    delay.find_each(&:categorise)
  end

  def self.refresh_content_all
    find_each(&:refresh_content)
  end

  def self.extract_content(node)
    title = node.at_xpath('.//title')
    link = node.at_xpath('.//link')
    pub_date = node.at_xpath('.//pubDate')
    description = node.at_xpath('.//description')

    if description.present?
      # Extract img src
      description = node_to_html(description)
      img_src = extract_img_src(description)

      # Remove img from description
      description.search('.//img').remove
    end

    {
      name: title.try(:content).try(:titleize),
      url: link.try(:content),
      description: description.try(:content).try(:strip),
      published_at: pub_date.try(:content) || Time.now.in_time_zone,
      imported_at: Time.now.in_time_zone,
      content_xml: node.to_xml,
      remote_image_url: img_src
    }
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

  def update_counter
    categories.update_all_recipes_count if approved_changed?
  end

  def refresh_content
    xml = Nokogiri::XML.fragment(content_xml)
    data = self.class.extract_content(xml)

    update(name: data[:name], description: data[:description])
  end

  def visits_count
    visit.try(:total_count) || 0
  end

  def visits_last_30_days_count
    visit.try(:last_30_days_count) || 0
  end

  def slug_id
    "#{ id }-#{ slug }"
  end

  private

  def self.node_to_html(node)
    html = CGI.unescapeHTML(node.to_html)

    Nokogiri::HTML.fragment(html)
  end

  def self.extract_img_src(node)
    return if node.blank?

    src = node.at_xpath('.//img/@src').try(:value)

    URI.encode(src) if src.present?
  end

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
