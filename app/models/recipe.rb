require 'uri'

class Recipe < ActiveRecord::Base
  include PgSearch
  extend FriendlyId

  has_attached_file :image, styles: { thumb: '100x100>' }
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

  scope :recent, -> (time_ago = 7.days.ago) { where('created_at >= ?', time_ago) }
  scope :popular, -> { order(bookmarks_count: :desc, created_at: :desc) }
  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where.not(approved: true) }

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

  private

  def matched_keywords
    Keyword.all.select do |keyword|
      keyword_name = Regexp.escape(keyword.name)
      regexp = /\b(?:#{ keyword_name }|#{ keyword_name.pluralize })\b/i
      regexp.match(name) || regexp.match(description)
    end
  end

  def slug_candidates
    [
      :name,
      [:name, -> { feed.name }]
    ]
  end
end
