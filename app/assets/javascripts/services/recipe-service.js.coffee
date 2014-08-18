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

      set: ->
        _.tap super, =>
          @attr 'trackingParams', {
            category: 'Recipe'
            action: 'Outbound'
            label: @data?.id
          }

      bookmarked: (user) ->
        user.bookmarks.bookmarked(this)
          .then (bookmarked) =>
            @status.bookmarked = bookmarked

    return Recipe

  .factory 'Recipes', (recipeResource, Collection, Recipe, RecipeOrderTypes) ->
    class Recipes extends Collection
      constructor: ->
        @configure {
          resource: recipeResource
          model: Recipe
          orderTypes: RecipeOrderTypes
        }

        super

      search: (params) ->
        @request('search', params)
          .then (recipes) => @set(recipes)

      orderBy: (type) ->
        @read({ order_by: type.key })
          .then (recipes) =>
            @status.orderedBy = type

            return recipes

    return Recipes

  .value 'RecipeOrderTypes', [
    { key: 'date', name: 'Date' }
    { key: 'bookmark', name: 'Bookmark' }
    { key: 'view', name: 'View' }
  ]
