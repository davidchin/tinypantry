require 'open-uri'

class Feed < ActiveRecord::Base
  # has_many :recipes

  def parse_rss
    xml_file = open(rss)
    xml = Nokogiri::XML(xml_file)
  end

  def import_rss
    xml = parse_rss

    xml.xpath('//item').map do |item|
      data = {
        name: item.at_xpath('.//title').content,
        url: item.at_xpath('.//link').content,
        description: item.at_xpath('.//description').content
      }

      Recipe.create(data)
    end
  end
end
