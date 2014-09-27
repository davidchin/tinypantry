json.cache! ['v1', 'index', @categories.current_page, @categories] do
  json.partial! 'api/v1/categories/category', collection: @categories, as: :category
end
