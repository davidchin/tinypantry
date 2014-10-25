angular.module('resource')
  .config ($provide) ->
    $provide.decorator '$resource', ($delegate) ->
      restfulActions =
        index:
          method: 'GET'
          isArray: true

        show:
          method: 'GET'

        create:
          method: 'POST'

        update:
          method: 'PUT'

        patch:
          method: 'PATCH'

        destroy:
          method: 'DELETE'

      return (url, params, actions) ->
        actions = _.extend({}, actions, restfulActions)

        $delegate(url, params, actions)
  
  .run ($rootScope, $cacheFactory) ->
    $rootScope.$on '$stateChangeSuccess', ->
      httpCache = $cacheFactory.get('$http')

      httpCache.removeAll()

  .factory 'attributeInterceptor', ($q) ->
    fromJson = (value) ->
      try obj = angular.fromJson(value)
      catch error then obj = null

    transformRequest = (config) ->
      config.params = _.underscoredObj(config.params)
      config.data = _.underscoredObj(config.data)

      config

    transformResponse = (response) ->
      response.data = _.camelizeObj(response.data)

      # Override header getter
      headersGetter = response.headers

      response.headers = (args...) ->
        header = headersGetter(args...)
        header = headerObj if (headerObj = fromJson(header))

        _.camelizeObj(header)

      response

    transformResponseError = (response) ->
      response = transformResponse(response)

      $q.reject(response)

    request: transformRequest
    response: transformResponse
    responseError: transformResponseError

  .factory 'httpCacheInterceptor', ($cacheFactory) ->
    transformRequest = (config) ->
      return config if config.method == 'GET'

      httpCache = $cacheFactory.get('$http')

      # Sweep all local cache
      httpCache.removeAll()

      return config

    request: transformRequest
