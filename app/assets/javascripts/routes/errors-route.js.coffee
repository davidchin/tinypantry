angular.module('error')
  .config ($stateProvider) ->
    $stateProvider
      .state 'errors',
        url: '/errors'
        abstract: true
        template: '<ui-view />'
        controller: 'ErrorsController'

      .state 'errors.404',
        url: '/404'
        templateUrl: 'errors/404.html'
