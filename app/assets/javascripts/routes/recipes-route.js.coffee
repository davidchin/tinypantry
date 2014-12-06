angular.module('recipe')
  .config ($stateProvider, $urlRouterProvider, ModalProvider) ->
    $stateProvider
      .state 'recipes',
        abstract: true
        template: '<ui-view />'

      .state 'recipes.index',
        url: '/?page&orderBy&query'
        templateUrl: 'recipes/index.html'
        controller: 'RecipesIndexController'
        reloadOnSearch: false

      .state 'recipes.category',
        url: '/recipes/category/:category?page&orderBy&query'
        templateUrl: 'recipes/index.html'
        controller: 'RecipesIndexController'
        reloadOnSearch: false

      .state 'recipes.edit',
        url: '/recipes/:id/edit'
        templateUrl: 'recipes/edit.html'
        controller:  'RecipesEditController'
        resolve: authorize: (authorize) -> authorize('admin')

      .state 'recipes.show',
        url: '/recipes/:id'
        templateUrl: 'recipes/show.html'
        controller:  'RecipesShowController'

      .state 'home',
        url: '/'
        onEnter: ['$timeout', '$state', ($timeout, $state) ->
          $timeout -> $state.go 'recipes.index', {}
        ]

    ModalProvider
      .when 'recipe',
        state: 'recipes.show'
        templateUrl: 'recipes/show-modal.html'
