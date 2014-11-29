angular.module('category')
  .config ($stateProvider) ->
    $stateProvider
      .state 'categories',
        url: '/categories'
        abstract: true
        template: '<ui-view />'

      .state 'categories.index',
        url: ''
        templateUrl: 'categories/index.html'
        controller: 'CategoriesIndexController'
        resolve: authorize: (authorize) -> authorize('admin')

      .state 'categories.new',
        url: '/new'
        templateUrl: 'categories/new.html'
        controller: 'CategoriesNewController'
        resolve: authorize: (authorize) -> authorize('admin')

      .state 'categories.show',
        url: '/:id'
        templateUrl: 'categories/show.html'
        controller: 'CategoriesShowController'
        resolve: authorize: (authorize) -> authorize('admin')

      .state 'categories.edit',
        url: '/:id/edit'
        templateUrl: 'categories/edit.html'
        controller: 'CategoriesEditController'
        resolve: authorize: (authorize) -> authorize('admin')
