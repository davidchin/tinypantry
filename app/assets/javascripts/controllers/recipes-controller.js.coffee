angular.module('recipe')
  .controller 'RecipesIndexController', ($scope, $routeParams, $location, $q, currentUser, Recipes) ->
    class RecipesIndexController
      constructor: ->
        @recipes = new Recipes

        @read()

      search: ->
        $location.path('/recipes').search({ query: @recipes.query })

      read: ->
        params = _.pick($routeParams, 'category', 'query')

        promise = if params.query?
          @recipes.search(params)
        else
          @recipes.read(params)

        promise
          .then => @bookmarked()
          .then => @recipes.data

      bookmarked: ->
        currentUser.ready()
          .then => $q.all(@recipes.invoke('bookmarked', currentUser))

    _.extend($scope, new RecipesIndexController)

  .controller 'RecipesShowController', ($routeParams, currentUser, flash, ga, Recipe) ->
    class RecipesShowController
      constructor: ->
        @recipe = new Recipe

        @read()

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

    _.extend($scope, new RecipesShowController)

  .controller 'RecipesEditController', ($routeParams, $location, flash, Recipe) ->
    class RecipesEditController
      constructor: ->
        @recipe = new Recipe

        @read()

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

    _.extend($scope, new RecipesEditController)
