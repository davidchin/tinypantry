angular.module('feed')
  .config ($stateProvider) ->
    $stateProvider
      .state 'feeds',
        url: '/feeds'
        abstract: true
        template: '<ui-view />'

      .state 'feeds.index',
        url: '?page'
        templateUrl: 'feeds/index.html'
        controller: 'FeedsIndexController'
        resolve: authorize: (authorize) -> authorize('admin')

      .state 'feeds.new',
        url: '/new'
        templateUrl: 'feeds/new.html'
        controller: 'FeedsNewController'
        resolve: authorize: (authorize) -> authorize('admin')

      .state 'feeds.show',
        url: '/:id'
        templateUrl: 'feeds/show.html'
        controller: 'FeedsShowController'
        resolve: authorize: (authorize) -> authorize('admin')

      .state 'feeds.edit',
        url: '/:id/edit'
        templateUrl: 'feeds/edit.html'
        controller: 'FeedsEditController'
        resolve: authorize: (authorize) -> authorize('admin')
