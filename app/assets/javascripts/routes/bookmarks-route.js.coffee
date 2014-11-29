angular.module('bookmark')
  .config ($stateProvider) ->
    $stateProvider
      .state 'bookmarks',
        url: '/bookmarks'
        abstract: true
        template: '<ui-view />'

      .state 'bookmarks.index',
        url: '?category&page&orderBy&query'
        templateUrl: 'bookmarks/index.html'
        controller: 'BookmarksIndexController'