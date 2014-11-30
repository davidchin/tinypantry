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
      related:
        method: 'GET'
        isArray: true
        url: '/api/recipes/:id/related'

    return $resource(path, params, actions)

  .factory 'Recipe', (recipeResource, Model) ->
    class Recipe extends Model
      constructor: ->
        @configure(resource: recipeResource)

        super

      read: (params) ->
        params?.id = parseInt(params?.id, 10)

        super
          .then (recipe) =>
            @trackingParams = {
              category: 'Recipe'
              action: 'Outbound'
              label: recipe.id
            }

            return recipe

      set: (data) ->
        output = super(data)
        @attr('slugId', [@id, @slug].join('-'))

        return output

      bookmarked: (user) ->
        user.bookmarks.bookmarked(this)
          .then (bookmark) =>
            @status.bookmarked = !!bookmark
            @bookmark = bookmark

      approve: (approved = true) ->
        @approved = approved
        @update()

      related: ->
        @request('related', { @id })
          .then (relatedRecipes) =>
            @relatedRecipes = for data in relatedRecipes
              recipe = new Recipe
              recipe.set(data)
              recipe

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

      read: (params) ->
        promise = if params?.query
          @search(params)
        else
          super

        promise
          .then (recipes) =>
            defaultOrder = _.first(@config.orderTypes)

            @status.orderedBy = params?.orderBy || defaultOrder.key

            return recipes

  .value 'RecipeOrderTypes', [
    { key: 'date', name: 'Date' }
    { key: 'bookmark', name: 'Bookmark' }
    { key: 'view', name: 'View' }
  ]
