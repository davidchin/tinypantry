angular.module('bookmark')
  .factory 'bookmarkResource', ($resource) ->
    path = '/api/users/:userId/bookmarks'
    params = { userId: '@userId' }
    actions =
      summary:
        method: 'GET'
        isArray: true
        cache: true
        url: '/api/users/:userId/bookmarks/summary'

    return $resource(path, params, actions)

  .factory 'Bookmark', (bookmarkResource, Model) ->
    class Bookmark extends Model
      constructor: ->
        @configure(resource: bookmarkResource)

        super

    return Bookmark

  .factory 'Bookmarks', (bookmarkResource, Collection, Bookmark, Recipe, RecipeOrderTypes) ->
    class Bookmarks extends Collection
      constructor: ->
        @configure {
          resource: bookmarkResource
          model: Bookmark
          orderTypes: RecipeOrderTypes
        }

        super

      search: (params) ->
        @request('search', params)
          .then (bookmarks) => @set(bookmarks)

      read: (params) ->
        promise = if params?.query?
          @search(params)
        else
          super

        promise
          .then (bookmarks) =>
            for bookmark in bookmarks
              bookmark.recipe = @transform(bookmark.recipe, { model: Recipe })

            defaultOrder = _.first(@config.orderTypes)

            @status.orderedBy = params?.orderBy || defaultOrder.key

            console.log(@status.orderedBy)

            return bookmarks

      bookmarked: (recipe) ->
        @request('summary')
          .then (bookmarks) ->
            _.any(bookmarks, { recipeId: recipe.id })

      params: ->
        { userId: @user?.id }

    return Bookmarks
