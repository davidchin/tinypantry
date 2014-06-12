require 'open-uri'

class Recipe < ActiveRecord::Base
  has_attached_file :image, styles: { thumb: '100x100>' }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  belongs_to :feed

  def remote_image_url=(url)
    self.image = URI.parse(url)
    super
  end
end
