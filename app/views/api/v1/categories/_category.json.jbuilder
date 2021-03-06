json.cache! ['v1', category] do
  json.extract! category, :id, :name, :slug, :recipes_count

  json.keywords do
    json.array! category.keywords, :id, :name
  end
end
