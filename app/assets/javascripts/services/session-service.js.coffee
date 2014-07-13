angular.module('session')
  .factory 'sessionService', ($http) ->
    create: (params, data) ->
      $http.post('/api/v1/login', data)
        .then (response) -> response.data

    destroy: (params, data) ->
      $http.delete('/api/v1/logout', data)
        .then (response) -> response.data

    verify: ->
      $http.get('/api/v1/verify')
        .then (response) -> response.data

  .factory 'sessionHttpInterceptor', ($injector) ->
    request: (config) ->
      if /^\/api\//i.test(config.url)
        currentUser = $injector.get('currentUser')
        token = currentUser.session.token()

        if token?
          config.headers['Authorization'] = "Token token=\"#{ token.secret }\", email=\"#{ token.key }\""

      return config

  .factory 'Session', ($q, sessionService, Model) ->
    class Session extends Model
      constructor: (config) ->
        @config =
          resource: sessionService

        super

      create: ->
        super.then (response) =>
          @store('auth_token', response.auth_token_secret) if response.auth_token_secret?
          @store('user', _.pick(response, 'id', 'email'))

          return response

      destroy: ->
        super.finally =>
          @store('auth_token', null)
          @store('user', null)

      verify: ->
        return $q.reject() unless @token()?.secret

        @request('verify')

      token: ->
        return unless @retrieve('auth_token')

        secret: @retrieve('auth_token')
        key: @retrieve('user')?.email

    return Session
