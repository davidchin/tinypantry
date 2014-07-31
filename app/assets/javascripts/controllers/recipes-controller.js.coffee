angular.module('recipe')
  .controller 'RecipesIndexController', ($routeParams, $location, $q, currentUser, Recipes) ->
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

    return new RecipesIndexController

  .controller 'RecipesShowController', ($routeParams, currentUser, flash, Recipe) ->
    class RecipesShowController
      constructor: ->
        @recipe = new Recipe

        @read()

      read: ->
        @recipe.read({ id: $routeParams.id })
          .then =>
            currentUser.ready().then => @recipe.bookmarked(currentUser)
          .then => @recipe.data

      bookmark: ->
        currentUser.ready()
          .then => currentUser.bookmarks.create({ recipe_id: @recipe.data.id })
          .then =>
            flash.set('Recipe is successfully bookmarked')
            @read()

    return new RecipesShowController

  .controller 'RecipesEditController', ($routeParams, $location, Recipe) ->
    class RecipesEditController
      constructor: ->
        @recipe = new Recipe

        @read()

      read: ->
        @recipe.read({ id: $routeParams.id })

      submit: ->
        @recipe.update()
          .then (recipe) ->
            $location.path('/recipes')

            return recipe

      destroy: ->
        @recipe.destroy
          .then (recipe) ->
            $location.path('/recipes')

            return recipe

    return new RecipesEditController
