angular.module('recipe')
  .controller 'RecipesIndexController', ($routeParams, $location, Recipes) ->
    class RecipesIndexController
      constructor: ->
        @recipes = new Recipes

        @read()

      search: ->
        $location.path('/recipes').search({ query: @recipes.query })

      read: ->
        params = _.pick($routeParams, 'category', 'query')

        if params.query?
          @recipes.search(params)
        else
          @recipes.read(params)

    return new RecipesIndexController

  .controller 'RecipesShowController', ($routeParams, Recipe) ->
    class RecipesShowController
      constructor: ->
        @recipe = new Recipe

        @read()

      read: ->
        @recipe.read({ id: $routeParams.id })

      bookmark: ->
        @recipe.bookmark()
          .then => @read()

    return new RecipesShowController
