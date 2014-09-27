json.cache! ['v1', 'index', @bookmarks.current_page, @bookmarks] do
  json.partial! 'api/v1/bookmarks/bookmark', collection: @bookmarks, as: :bookmark
end
