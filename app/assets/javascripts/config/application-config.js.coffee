angular.module('config')
  .config ($sceDelegateProvider) ->
    $sceDelegateProvider.resourceUrlWhitelist [
      'self'
      'http://assets.tinypantry.com/**'
      'https://assets.tinypantry.com/**'
    ]

  .config ($locationProvider) ->
    $locationProvider.hashPrefix('!')
    $locationProvider.html5Mode(true)

  .config (localStorageServiceProvider) ->
    localStorageServiceProvider.setPrefix('tinypantry')

  .config ($httpProvider) ->
    acceptHeader = $httpProvider.defaults.headers.common['Accept']
    $httpProvider.defaults.headers.common['Accept'] = "application/vnd.tinypantry.v1, #{ acceptHeader }"

    $httpProvider.interceptors.unshift('attributeInterceptor')
    $httpProvider.interceptors.push('httpCacheInterceptor')
    $httpProvider.interceptors.push('sessionHttpInterceptor')

  .config ($animateProvider) ->
    $animateProvider.classNameFilter(/^(?:(?!ng-animate--disabled).)*$/)
