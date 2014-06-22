class RecipesController

class RecipesIndexController extends RecipesController
  @$inject: ['$log'],

  constructor: ($log) ->
    $log.info('Hello')

class RecipesShowController extends RecipesController

# Declare controllers
angular.module('Recipes')
  .controller('RecipesIndexController', RecipesIndexController)
  .controller('RecipesShowController', RecipesShowController)
