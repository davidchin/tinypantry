json.cache! ['v1', feed] do
  json.extract! feed, :id, :name, :url, :rss, :last_imported
end
