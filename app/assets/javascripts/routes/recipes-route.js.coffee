angular.module('recipe')
  .config ($stateProvider, $urlRouterProvider, ModalProvider) ->
    $stateProvider
      .state 'recipes',
        url: '/?category&page&orderBy&query'
        abstract: true
        template: '<ui-view />'
        controller: 'RecipesIndexController'

      .state 'recipes.index',
        url: ''
        templateUrl: 'recipes/index.html'

      .state 'recipes.category',
        url: 'recipes/category/:id'
        onEnter: ['$timeout', '$state', ($timeout, $state) ->
          $timeout -> $state.go 'recipes.index', { category: $state.params.id }
        ]

      .state 'recipes.edit',
        url: 'recipes/:id/edit'
        templateUrl: 'recipes/edit.html'
        controller:  'RecipesEditController'
        resolve: authorize: (authorize) -> authorize('admin')

      .state 'recipes.show',
        url: 'recipes/:id'
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
