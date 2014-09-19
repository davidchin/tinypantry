angular.module('bookmark')
  .controller 'BookmarksIndexController', ($scope, $state, currentUser, BaseController, Bookmarks, Modal) ->
    class BookmarksIndexController extends BaseController
      constructor: ->
        @user = currentUser
        @bookmarks = @user.bookmarks
        @recipes = @user.bookmarkedRecipes

        @recipeModal = new Modal({ scope: $scope })

        @read()

        super($scope)

      search: ->
        $state.go('bookmarks.index', { query: @recipes.query })

      openRecipe: (recipe) ->
        @recipeModal.open('recipe', { id: recipe.id })

      closeRecipe: ->
        @recipeModal.close()

      read: (params, append) ->
        params = _.defaults({}, params, $state.params)
        method = if append then 'append' else 'read'

        @user.ready()
          .then => @recipes[method](params)

      next: (params) ->
        params = _.defaults({ page: @recipes.pagination.nextPage }, params)

        @read(params, true) if params.page

      orderBy: (key) ->
        $state.go($state.current, { orderBy: key })

    new BookmarksIndexController
