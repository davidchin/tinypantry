angular.module('recipe')
  .controller 'RecipesIndexController', ($scope, $state, $q, currentUser, BaseController, Recipes, Modal) ->
    class RecipesIndexController extends BaseController
      constructor: ->
        @recipes = new Recipes
        @recipeModal = new Modal({ scope: $scope })

        @read()

        super($scope)

      search: ->
        $state.go('recipes.index', { query: @recipes.query })

      openRecipe: (recipe) ->
        @recipeModal.open('recipe', { id: recipe.id })

      closeRecipe: ->
        @recipeModal.close()

      read: (params, append) ->
        routeParams = _.pick($state.params, 'category', 'query', 'orderBy')
        params = _.defaults({}, params, routeParams)
        method = if append then 'append' else 'read'

        @recipes[method](params)
          .then => @bookmarked()
          .then => @recipes.data()

      next: (params) ->
        params = _.defaults({ page: @recipes.pagination.nextPage }, params)

        @read(params, true) if params.page

      orderBy: (key) ->
        $state.go($state.current, { orderBy: key })

      bookmarked: ->
        currentUser.ready()
          .then => $q.all(@recipes.invoke('bookmarked', currentUser))

    new RecipesIndexController

  .controller 'RecipesShowController', ($scope, $stateParams, currentUser, flash, ga, BaseController, Recipe) ->
    class RecipesShowController extends BaseController
      constructor: ->
        @recipe = new Recipe

        @read()

        super($scope)

      read: ->
        @recipe.read({ id: $stateParams.id })
          .then =>
            # NOTE: This 'then' block is for testing - to be removed later
            { category, action, label } = @recipe.trackingParams
            ga.event(category, action, label)
            @recipe
          .then =>
            currentUser.ready()
              .then => @recipe.bookmarked(currentUser)
          .then => @recipe.data()

      bookmark: ->
        currentUser.ready()
          .then => currentUser.bookmarks.create({ recipeId: @recipe.id })
          .then =>
            flash.set('Recipe was successfully bookmarked.')
            @read()

    new RecipesShowController

  .controller 'RecipesEditController', ($scope, $state, flash, BaseController, Recipe) ->
    class RecipesEditController extends BaseController
      constructor: ->
        @recipe = new Recipe

        @read()

        super($scope)

      read: ->
        @recipe.read({ id: $state.params.id })

      submit: ->
        @recipe.update()
          .then (recipe) ->
            flash.set('Feed was successfully updated.')
            $state.go('recipes.index')

            return recipe

      destroy: ->
        @recipe.destroy
          .then (recipe) ->
            flash.set('Feed was successfully destroyed.')
            $state.go('recipes.index')

            return recipe

    new RecipesEditController
