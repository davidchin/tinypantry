angular.module('bookmark')
  .factory 'bookmarkResource', ($resource) ->
    path = '/api/users/:userId/bookmarks/:id'
    params = { userId: '@userId' }
    actions =
      summary:
        method: 'GET'
        isArray: true
        url: '/api/users/:userId/bookmarks/summary'

    return $resource(path, params, actions)

  .factory 'bookmarkedRecipeResource', ($resource) ->
    path = '/api/users/:userId/bookmarked-recipes'
    params = { userId: '@userId' }
    actions =
      search:
        method: 'GET'
        isArray: true
        url: '/api/users/:userId/bookmarked-recipes/search'

    return $resource(path, params, actions)

  .factory 'Bookmark', (bookmarkResource, Model) ->
    class Bookmark extends Model
      constructor: ->
        @configure(resource: bookmarkResource)

        super

    return Bookmark

  .factory 'Bookmarks', (bookmarkResource, Collection, Bookmark, Recipe) ->
    class Bookmarks extends Collection
      constructor: ->
        @configure {
          resource: bookmarkResource
          model: Bookmark
        }

        super

      read: ->
        super
          .then (bookmarks) =>
            for bookmark in bookmarks
              bookmark.recipe = @transform(bookmark.recipe, { model: Recipe })

            return bookmarks

      bookmarked: (recipe) ->
        @request('summary')
          .then (bookmarks) ->
            _.find(bookmarks, { recipeId: recipe.id })

      params: ->
        { userId: @user?.id }

    return Bookmarks

  .factory 'BookmarkedRecipes', (bookmarkedRecipeResource, Collection, Recipe, RecipeOrderTypes) ->
    class BookmarkedRecipes extends Collection
      constructor: ->
        @configure {
          resource: bookmarkedRecipeResource
          model: Recipe
          orderTypes: RecipeOrderTypes
        }

        super

      params: ->
        { userId: @user?.id }

      search: (params) ->
        @request('search', params)
          .then (recipes) => @set(recipes)

      read: (params) ->
        promise = if params?.query?
          @search(params)
        else
          super

        promise
          .then (recipes) =>
            defaultOrder = _.first(@config.orderTypes)

            @status.orderedBy = params?.orderBy || defaultOrder.key

            return recipes

    return BookmarkedRecipes
