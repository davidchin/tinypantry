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
        data.keywords = [] unless data.keywords

        output = super(data)
        @attr('slugId', [@id, @slug].join('-'))

        return output

      data: ->
        output = super

        output.keywords = _.filter output.keywords, (keyword) ->
          return true unless !keyword.id && !keyword.name

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

      request: (action, params, data) ->
        action = 'search' if action == 'index' && params?.query

        super(action, params, data)

      read: (params) ->
        @orderBy = params?.orderBy || _.first(@config.orderTypes)?.key
        @category = params?.category
        @categoryName = _.str.humanize(@category)

        if params?.page > 1
          @readAll(params)
        else
          super

  .value 'RecipeOrderTypes', [
    { key: 'date', name: 'Date' }
    { key: 'bookmark', name: 'Bookmark' }
    { key: 'view', name: 'View' }
  ]
