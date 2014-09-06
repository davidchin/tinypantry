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

  .config ($httpProvider) ->
    $httpProvider.interceptors.unshift('attributeInterceptor')

  .factory 'attributeInterceptor', ->
    transformRequest = (config) ->
      config.params = _.underscoredObj(config.params)

      config

    transformResponse = (response) ->
      if _.isArray(response.data)
        response.data[i] = _.camelizeObj(obj) for obj, i in response.data
      else if _.isPlainObject(response.data)
        response.data = _.camelizeObj(response.data)

      response

    request: transformRequest
    response: transformResponse
    responseError: transformResponse
