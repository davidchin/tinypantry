angular.module('recipe')
  .factory 'recipeResource', ($resource) ->
    path = '/api/recipes/:id'
    params = { id: '@id' }
    actions =
      search:
        method: 'GET'
        isArray: true
        url: '/api/recipes/search'
      bookmark:
        method: 'POST'
        url: '/api/recipes/:id/bookmark'

    return $resource(path, params, actions)

  .factory 'Recipe', (recipeResource, Model) ->
    class Recipe extends Model
      constructor: ->
        @configure(resource: recipeResource)

        super

      bookmarked: (user) ->
        user.bookmarks.bookmarked(this)
          .then (bookmarked) =>
            @status.bookmarked = bookmarked

    return Recipe

  .factory 'Recipes', (recipeResource, Collection, Recipe) ->
    class Recipes extends Collection
      constructor: ->
        @configure {
          resource: recipeResource
          model: Recipe
        }

        super

      search: (params) ->
        @request('search', params)
          .then (recipes) => @set(recipes)

    return Recipes
