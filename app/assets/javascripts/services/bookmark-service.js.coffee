angular.module('bookmark')
  .factory 'bookmarkResource', ($resource) ->
    path = '/api/users/:user_id/bookmarks'
    params = { user_id: '@user_id' }
    actions =
      recipes:
        method: 'GET'
        isArray: true
        url: '/api/users/:user_id/bookmarks/recipes'

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
          .then => @any({ recipe_id: recipe.data.id })

      recipes: (params) ->
        @request('recipes', params)
          .then (response) => @set(response)

      params: ->
        { user_id: @user?.data.id }

    return Bookmarks
