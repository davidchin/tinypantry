angular.module('config')
  .config ($locationProvider) ->
    $locationProvider.html5Mode(true)

  .config (localStorageServiceProvider) ->
    localStorageServiceProvider.setPrefix('tinypantry')
