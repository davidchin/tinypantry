json.cache! ['v1', 'summary', @bookmarks] do
  json.array! @bookmarks do |bookmark|
    json.extract! bookmark, :id, :recipe_id
  end
end
