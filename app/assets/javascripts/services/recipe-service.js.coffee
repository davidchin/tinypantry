angular.module('recipe')
  .factory 'recipeResource', ($resource) ->
    path = '/api/v1/recipes/:id'
    params = { id: '@id' }
    actions =
      search:
        method: 'GET'
        isArray: true
        url: '/api/v1/recipes/search'
      bookmark:
        method: 'POST'
        url: '/api/v1/recipes/:id/bookmark'

    return $resource(path, params, actions)

  .factory 'Recipe', (recipeResource, Model) ->
    class Recipe extends Model
      constructor: ->
        @config =
          resource: recipeResource

        super

      bookmark: (params) ->
        @request('bookmark', _.extend({ id: @data.id }, params))

      bookmarked: (user) ->
        user.bookmarks()
          .then (bookmarks) =>
            @status.bookmarked = _.any(bookmarks, { recipe_id: @data.id })

    return Recipe

  .factory 'Recipes', (recipeResource, Collection, Recipe) ->
    class Recipes extends Collection
      constructor: ->
        @config =
          resource: recipeResource
          model: Recipe

        super

      search: (params) ->
        @request('search', params)
          .then (recipes) => @set(recipes)

    return Recipes
