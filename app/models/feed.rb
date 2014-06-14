require 'cgi'

class Feed < ActiveRecord::Base
  has_many :recipes

  def parse_rss
    xml_file = open(rss)
    Nokogiri::XML(xml_file)
  end

  def import_rss
    new_recipes = find_fresh_items.map do |item|
      recipes.new(extract_recipe_data(item))
    end

    return if new_recipes.empty?

    Feed.transaction do
      new_recipes.each(&:save)
      update(last_imported: Time.zone.now)
    end
  end

  def find_fresh_items
    urls = recipes.pluck(:url)

    parse_rss.xpath('//item').reject do |item|
      link = item.at_xpath('.//link')

      urls.include?(link.try(:content))
    end
  end

  def recent_recipes(time_ago = 7.days.ago)
    recipes.where('created_at >= ?', time_ago)
  end

  def self.import_all
    all.map do |feed|
      feed.delay.import_rss
    end
  end

  private

  def find_img_src(node)
    return if node.blank?

    html = CGI.unescapeHTML(node.to_html)
    html = Nokogiri::HTML.fragment(html)
    html.at_xpath('.//img/@src').try(:value)
  end

  def extract_recipe_data(node)
    title = node.at_xpath('.//title')
    link = node.at_xpath('.//link')
    description = node.at_xpath('.//description')

    {
      name: title.try(:content),
      url: link.try(:content),
      description: description.try(:content),
      content_xml: node.to_xml,
      remote_image_url: find_img_src(description)
    }
  end
end
