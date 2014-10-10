angular.module('loading')
  .factory 'loadingIndicatorManager', ($rootScope) ->
    start: (id) ->
      $rootScope.$broadcast('loadingIndicator:start', id) if id?

    stop: (id) ->
      $rootScope.$broadcast('loadingIndicator:stop', id) if id?
