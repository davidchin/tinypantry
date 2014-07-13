angular.module('config')
  .config ($locationProvider) ->
    $locationProvider.hashPrefix('!')
    $locationProvider.html5Mode(true)

  .config (localStorageServiceProvider) ->
    localStorageServiceProvider.setPrefix('tinypantry')

  .config ($httpProvider) ->
    $httpProvider.interceptors.push('sessionHttpInterceptor')
