json.cache! ['v1', 'index', @feeds] do
  json.partial! 'api/v1/feeds/feed', collection: @feeds, as: :feed
end
