json.cache! ['v1', bookmark] do
  json.merge! bookmark.attributes

  json.recipe do
    json.partial! 'api/v1/recipes/recipe', recipe: bookmark.recipe
  end
end
