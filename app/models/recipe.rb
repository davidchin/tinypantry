require 'uri'

class Recipe < ActiveRecord::Base
  has_attached_file :image, styles: { thumb: '100x100>' }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  belongs_to :feed
  has_many :categorisations, as: :keywordable
  has_many :keywords, through: :categorisations
  has_many :categories, through: :keywords

  def remote_image_url=(url)
    begin
      url = URI.encode(url) if url.present?
      self.image = URI.parse(url)
      super
    rescue URI::Error
      false
    end
  end

  def self.recent(time_ago = 7.days.ago)
    where('created_at >= ?', time_ago)
  end
end
