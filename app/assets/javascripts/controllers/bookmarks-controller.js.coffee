angular.module('bookmark')
  .controller 'BookmarksIndexController', ($scope, $state, $stateParams, $q, currentUser, BaseController, Bookmarks, Modal) ->
    class BookmarksIndexController extends BaseController
      constructor: ->
        @currentUser = currentUser
        @bookmarks = @currentUser.bookmarks
        @recipes = @currentUser.bookmarkedRecipes

        @recipeModal = new Modal({ scope: $scope })

        @recipes.status.set = false
        @read()

        super($scope)

      search: ->
        $state.go('bookmarks.index', { query: @recipes.query })

      openRecipe: (recipe, event) ->
        event.preventDefault() if event?
        @recipeModal.open('recipe', { id: recipe.id })

      closeRecipe: ->
        @recipeModal.close()

      read: (params, append) ->
        params = _.defaults({}, params, $stateParams)

        # Determine method
        method = if append then 'append' else 'read'

        @currentUser.ready()
          .then => @recipes[method](params)

      next: (params) ->
        params = _.defaults({ page: @recipes.pagination.nextPage }, params)

        @read(params, true) if params.page

      orderBy: (key) ->
        $state.go($state.current, { orderBy: key })

    new BookmarksIndexController
