class Feed < ActiveRecord::Base
  has_many :recipes, dependent: :destroy

  def self.import_all
    find_each(&:delay_import_rss)
  end

  def parse_rss
    xml_file = open(rss)
    Nokogiri::XML(xml_file)
  end

  def import_rss
    new_recipes = fresh_items.map do |item|
      recipes.new(Recipe.extract_content(item))
    end

    return if new_recipes.empty?

    transaction do
      new_recipes.each(&:save)
      update(last_imported: Time.now.in_time_zone)
    end
  end

  def delay_import_rss
    delay.import_rss
  end

  def fresh_items
    urls = recipes.pluck(:url)

    parse_rss.xpath('//item').reject do |item|
      link = item.at_xpath('.//link')

      urls.include?(link.try(:content))
    end
  end
end
