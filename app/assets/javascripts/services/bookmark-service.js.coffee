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

  .factory 'Bookmarks', (bookmarkResource, Collection, Bookmark, Recipe) ->
    class Bookmarks extends Collection
      constructor: ->
        @configure {
          resource: bookmarkResource
          model: Bookmark
        }

        super

      read: (params) ->
        super
          .then (bookmarks) =>
            for bookmark in bookmarks
              bookmark.recipe = @transform(bookmark.recipe, { model: Recipe })

            return bookmarks

      bookmarked: (recipe) ->
        @request('summary')
          .then (bookmarks) ->
            _.any(bookmarks, { recipeId: recipe.id })

      params: ->
        { userId: @user?.id }

    return Bookmarks
