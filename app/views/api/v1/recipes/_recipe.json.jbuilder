json.cache! ['v1', recipe] do
  json.extract! recipe, :id,
                        :name,
                        :description,
                        :published_at,
                        :slug,
                        :url,
                        :bookmarks_count,
                        :image_urls,
                        :approved
  json.feed do
    json.partial! 'api/v1/feeds/feed', feed: recipe.feed
  end
end
