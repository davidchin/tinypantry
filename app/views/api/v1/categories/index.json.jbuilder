json.cache! ['v1', 'index', @categories] do
  json.partial! 'api/v1/categories/category', collection: @categories, as: :category
end
