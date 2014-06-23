angular.module('Routes')
  .config ($routeProvider, $locationProvider) ->
    $locationProvider.html5Mode(true)

    $routeProvider
      .when('/recipes', {
        templateUrl: '/assets/recipes/index.html',
        controller:  'RecipesIndexController'
      })

      .when('/recipes/:id', {
        templateUrl: '/assets/recipes/show.html',
        controller:  'RecipesShowController'
      })
