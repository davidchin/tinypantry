angular.module('bookmark')
  .config ($stateProvider) ->
    $stateProvider
      .state 'bookmarks',
        url: '/bookmarks?category&page&orderBy&query'
        abstract: true
        template: '<ui-view />'
        controller: 'BookmarksIndexController'

      .state 'bookmarks.index',
        url: ''
        templateUrl: 'bookmarks/index.html'
