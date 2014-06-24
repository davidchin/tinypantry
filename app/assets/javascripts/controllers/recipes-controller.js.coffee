RecipesIndexController = (recipeResource) ->
  recipeResource.index().$promise
    .then (response) ->
      console.log(response)

RecipesShowController = (recipeResource, $routeParams) ->
  recipeResource.show({ id: $routeParams.id }).$promise
    .then (response) ->
      console.log(response)

# Register controllers
angular.module('recipe')
  .controller('RecipesIndexController', RecipesIndexController)
  .controller('RecipesShowController', RecipesShowController)
