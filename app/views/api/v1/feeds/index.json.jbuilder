json.cache! ['v1', 'index', @feeds.current_page, @feeds] do
  json.partial! 'api/v1/feeds/feed', collection: @feeds, as: :feed
end
