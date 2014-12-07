angular.module('bookmark')
  .factory 'bookmarkResource', ($resource) ->
    path = '/api/users/:userId/bookmarks/:id'
    params = { userId: '@userId' }
    actions =
      summary:
        method: 'GET'
        isArray: true
        cache: true
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
