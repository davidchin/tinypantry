angular.module('bookmark')
  .controller 'BookmarksController', ($scope, BaseController) ->
    class BookmarksController extends BaseController
      constructor: ->
        @params = {}

        super($scope)

    new BookmarksController

  .controller 'BookmarksIndexController', ($scope, $state, $stateParams, $q, currentUser, BaseController, Bookmarks, Modal) ->
    class BookmarksIndexController extends BaseController
      constructor: ->
        @currentUser = currentUser
        @bookmarks = @currentUser.bookmarks
        @recipes = @currentUser.bookmarkedRecipes

        @recipeModal = new Modal({ scope: $scope })

        @recipes.unset()
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
        parentParams = $scope.$parent.params
        params = _.defaults({}, params, $stateParams)
        data = @recipes.data()

        # If request is already fulfilled, return existing data
        return $q.when(data) unless !_.compareObj(parentParams, params) || _.isEmpty(data)

        # Merge with parent params and retain
        _.emptyObj(parentParams) unless _.compareObj(parentParams, params, ['category', 'orderBy', 'query'])

        params = _.defaults(parentParams, params)

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
