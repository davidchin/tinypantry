angular.module('recipe')
  .controller 'RecipesIndexController', (Recipes) ->
    class RecipesIndexController
      constructor: ->
        @recipes = new Recipes

        @read()

      read: ->
        @recipes.read()

    return new RecipesIndexController

  .controller 'RecipesShowController', ($routeParams, Recipe) ->
    class RecipesShowController
      constructor: ->
        @recipe = new Recipe

        @read()

      read: ->
        @recipe.read({ id: $routeParams.id })

    return new RecipesShowController
