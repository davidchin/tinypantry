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
      recipes.new(extract_recipe_data(item))
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

  private

  def extract_img_src(node)
    return if node.blank?

    html = CGI.unescapeHTML(node.to_html)
    html = Nokogiri::HTML.fragment(html)
    src = html.at_xpath('.//img/@src').try(:value)

    URI.encode(src) if src.present?
  end

  def extract_recipe_data(node)
    title = node.at_xpath('.//title')
    link = node.at_xpath('.//link')
    description = node.at_xpath('.//description')
    pub_date = node.at_xpath('.//pubDate')
    img_src = extract_img_src(description)

    description.search('.//img').remove if description.present?

    {
      name: title.try(:content),
      url: link.try(:content),
      description: description.try(:content),
      published_at: pub_date.try(:content),
      imported_at: Time.now.in_time_zone,
      content_xml: node.to_xml,
      remote_image_url: img_src
    }
  end
end
