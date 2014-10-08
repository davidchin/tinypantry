json.cache! prepend_roles!(['v1', 'index', recipes]) do
  json.partial! 'api/v1/recipes/recipe', collection: recipes, as: :recipe
end
