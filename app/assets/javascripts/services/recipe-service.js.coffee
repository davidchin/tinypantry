angular.module('recipe')
  .factory 'recipeResource', ($resource) ->
    path = "/api/v1/recipes/:id"
    params = { id: '@id' }
    actions =
      search:
        method: 'GET'
        isArray: true
        path: "/api/v1/recipes/search"

    return $resource(path, params, actions)

  .factory 'Recipe', (recipeResource, Model) ->
    class Recipe extends Model
      constructor: ->
        @config =
          resource: recipeResource

        super

    return Recipe

  .factory 'Recipes', (recipeResource, Collection, Recipe) ->
    class Recipes extends Collection
      constructor: ->
        @config =
          resource: recipeResource
          model: Recipe

        super

    return Recipes
