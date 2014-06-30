angular.module('session')
  .factory 'sessionService', ($http, $cookieStore) ->
    create: (params, data) ->
      $http.post('/api/v1/login', data)
        .success (response) =>
          @store('auth_token', response.auth_token) if response.auth_token?

    destroy: ->
      $http.delete('/api/v1/logout', { auth_token: @authToken() })
        .success ->
          $cookieStore.remove('auth_token')

    store: (key, value) ->
      $cookieStore.put(key, value)

      return value

    authToken: ->
      return $cookieStore.get('auth_token')

  .factory 'Session', (sessionService, Model) ->
    class Session extends Model
      constructor: (config) ->
        defaults =
          resource: sessionService

        config = _.extend(defaults, config)

        super(config)

    return Session
