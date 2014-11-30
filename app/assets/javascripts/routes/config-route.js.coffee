angular.module('config')
  .config ($stateProvider, $urlRouterProvider) ->
    $urlRouterProvider
      .otherwise '/errors/404'
      .when '/recipes', '/'
      .when '/', ($location) ->
        fragment = $location.search()['_escaped_fragment_']
 
        if _.isString(fragment)
          return decodeURIComponent(fragment)
        else
          return false
