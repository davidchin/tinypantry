angular.module('bookmark')
  .factory 'bookmarkResource', ($resource) ->
    path = '/api/users/:userId/bookmarks'
    params = { userId: '@userId' }
    actions =
      recipes:
        method: 'GET'
        isArray: true
        url: '/api/users/:userId/bookmarks/recipes'

    return $resource(path, params, actions)

  .factory 'Bookmark', (bookmarkResource, Model) ->
    class Bookmark extends Model
      constructor: ->
        @configure(resource: bookmarkResource)

        super

    return Bookmark

  .factory 'Bookmarks', (bookmarkResource, Collection, Bookmark) ->
    class Bookmarks extends Collection
      constructor: ->
        @configure {
          resource: bookmarkResource
          model: Bookmark
        }

        super

      bookmarked: (recipe) ->
        @read()
          .then => @any({ recipeId: recipe.id })

      recipes: (params) ->
        @request('recipes', params)
          .then (response) => @set(response)

      params: ->
        { userId: @user?.id }

    return Bookmarks
