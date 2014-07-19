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
        currentUser.ready().then =>
          promises = for recipe in @recipes.data
            recipe.bookmarked(currentUser)

          $q.all(promises)

    return new RecipesIndexController

  .controller 'RecipesShowController', ($routeParams, currentUser, Recipe) ->
    class RecipesShowController
      constructor: ->
        @recipe = new Recipe

        @read()

      read: ->
        @recipe.read({ id: $routeParams.id })
          .then =>
            currentUser.ready().then =>
              @recipe.bookmarked(currentUser)
          .then => @recipe.data

      bookmark: ->
        @recipe.bookmark()
          .then => @read()

    return new RecipesShowController
