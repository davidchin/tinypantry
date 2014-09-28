json.cache! ['v1', 'index', @bookmarks] do
  json.partial! 'api/v1/bookmarks/bookmark', collection: @bookmarks, as: :bookmark
end
