json.cache! ['v1', 'index', can?(:manage, :recipe) ? 'all' : 'approved', @recipes.current_page, @recipes] do
  json.partial! 'api/v1/recipes/recipe', collection: @recipes, as: :recipe
end
