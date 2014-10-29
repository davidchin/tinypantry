angular.module('loading')
  .run ($rootScope, raLoadingProgress) ->
    $rootScope.loadingProgress = raLoadingProgress

    $rootScope.$on '$stateChangeSuccess', -> raLoadingProgress.reset()

  .factory 'loadingIndicatorManager', ($rootScope) ->
    start: (id) ->
      $rootScope.$broadcast('loadingIndicator:start', id) if id?

    stop: (id) ->
      $rootScope.$broadcast('loadingIndicator:stop', id) if id?
