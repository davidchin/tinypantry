require 'uri'

class Recipe < ActiveRecord::Base
  has_attached_file :image, styles: { thumb: '100x100>' }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  after_create :categorise

  belongs_to :feed
  has_many :categorisations, as: :keywordable, dependent: :destroy
  has_many :keywords, through: :categorisations
  has_many :categories, -> { group('categories.id').order('count(categories.id) desc') },
           through: :keywords

  scope :recent, -> (time_ago = 7.days.ago) { where('created_at >= ?', time_ago) }
  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where.not(approved: true) }

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
end
