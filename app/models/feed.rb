require 'open-uri'

class Feed < ActiveRecord::Base
  has_many :recipes

  def parse_rss
    # TODO: async process, as downloading data might take some time
    xml_file = open(rss)
    xml = Nokogiri::XML(xml_file)
  end

  def import_rss
    new_recipes = fresh_items.map do |item|
      title = item.at_xpath('.//title'),
      link = item.at_xpath('.//link'),
      description = item.at_xpath('.//description')

      data = {
        name: title.try(:content),
        url: link.try(:content),
        description: description.try(:content)
      }

      recipes.new(data)
    end

    if new_recipes.any?
      Feed.transaction do
        new_recipes.each(&:save)
        update(last_imported: Time.zone.now)
      end
    end
  end

  def fresh_items
    urls = recipes.pluck(:url)

    parse_rss.xpath('//item').reject do |item|
      link = item.at_xpath('.//link')

      urls.include?(link.try(:content))
    end
  end
end
