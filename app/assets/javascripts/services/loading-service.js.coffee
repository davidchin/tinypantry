angular.module('loading')
  .factory 'loadingIndicatorManager', ($rootScope) ->
    start: (id) ->
      $rootScope.$broadcast('start.loadingIndicator', id) if id?

    stop: (id) ->
      $rootScope.$broadcast('stop.loadingIndicator', id) if id?
