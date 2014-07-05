angular.module('recipe')
  .controller 'RecipesIndexController', (Recipes) ->
    class RecipesIndexController
      constructor: ->
        @recipes = new Recipes

        @get()

      get: ->
        @recipes.read()

    return new RecipesIndexController

  .controller 'RecipesShowController', ($routeParams, Recipe) ->
    class RecipesShowController
      constructor: ->
        @recipe = new Recipe

        @get()

      get: ->
        @recipe.show({ id: $routeParams.id })

    return new RecipesShowController
