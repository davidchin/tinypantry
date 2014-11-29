xml.instruct! :xml, version: '1.0'
xml.urlset 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do

  xml.url do
    xml.loc root_url
    xml.changefreq 'weekly'
    xml.priority 1.0
  end

  xml.url do
    xml.loc recipes_url
    xml.lastmod @recipes.last_updated_at.strftime('%FT%T%:z')
    xml.changefreq 'weekly'
    xml.priority 0.9
  end

  cache @recipes do
    @recipes.each do |recipe|
      cache recipe do
        xml.url do
          xml.loc recipe_url(id: recipe.slug_id)
          xml.lastmod recipe.updated_at.strftime('%FT%T%:z')
          xml.changefreq 'weekly'
          xml.priority 0.8
        end
      end
    end
  end

  cache @categories do
    @categories.each do |category|
      cache category do
        xml.url do
          xml.loc category_url(category)
          xml.lastmod category.updated_at.strftime('%FT%T%:z')
          xml.changefreq 'weekly'
          xml.priority 0.8
        end
      end
    end
  end

end
