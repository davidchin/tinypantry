json.cache! ['v1', recipe] do
  json.extract! recipe, :id,
                        :name,
                        :description,
                        :published_at,
                        :slug,
                        :url,
                        :remote_image_url,
                        :bookmarks_count,
                        :image_urls,
                        :approved,
                        :visits_count

  json.feed do
    json.partial! 'api/v1/feeds/feed', feed: recipe.feed
  end

  json.keywords do
    json.array! recipe.keywords do |keyword|
      json.id keyword.id
      json.name keyword.name
      json.hidden keyword.hidden?(recipe)
    end
  end
end
