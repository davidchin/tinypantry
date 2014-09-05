angular.module('recipe')
  .controller 'RecipesIndexController', ($scope, $routeParams, $location, $q, currentUser, BaseController, Recipes) ->
    class RecipesIndexController extends BaseController
      constructor: ->
        @recipes = new Recipes

        @read()

        super($scope)

      search: ->
        $location.path('/recipes').search({ query: @recipes.query })

      read: (params) ->
        routeParams = _.pick($routeParams, 'category', 'query')
        params = _.defaults({}, params, routeParams)

        @recipes.read(params)
          .then => @bookmarked()
          .then => @recipes.data

      orderBy: (key) ->
        @read({ order_by: key })

      bookmarked: ->
        currentUser.ready()
          .then => $q.all(@recipes.invoke('bookmarked', currentUser))

    new RecipesIndexController

  .controller 'RecipesShowController', ($scope, $routeParams, currentUser, flash, ga, BaseController, Recipe) ->
    class RecipesShowController extends BaseController
      constructor: ->
        @recipe = new Recipe

        @read()

        super($scope)

      read: ->
        @recipe.read({ id: $routeParams.id })
          .then =>
            # NOTE: This 'then' block is for testing - to be removed later
            { category, action, label } = @recipe.data.trackingParams
            ga.event(category, action, label)
          .then =>
            currentUser.ready().then => @recipe.bookmarked(currentUser)
          .then => @recipe.data

      bookmark: ->
        currentUser.ready()
          .then => currentUser.bookmarks.create({ recipe_id: @recipe.data.id })
          .then =>
            flash.set('Recipe was successfully bookmarked.')
            @read()

    new RecipesShowController

  .controller 'RecipesEditController', ($scope, $routeParams, $location, flash, BaseController, Recipe) ->
    class RecipesEditController extends BaseController
      constructor: ->
        @recipe = new Recipe

        @read()

        super($scope)

      read: ->
        @recipe.read({ id: $routeParams.id })

      submit: ->
        @recipe.update()
          .then (recipe) ->
            flash.set('Feed was successfully updated.')
            $location.path('/recipes')

            return recipe

      destroy: ->
        @recipe.destroy
          .then (recipe) ->
            flash.set('Feed was successfully destroyed.')
            $location.path('/recipes')

            return recipe

    new RecipesEditController
