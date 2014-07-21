angular.module('session')
  .run ($rootScope, $cacheFactory) ->
    $rootScope.$on '$routeChangeSuccess', ->
      httpCache = $cacheFactory.get('$http')

      httpCache.removeAll()

  .factory 'sessionService', ($http) ->
    create: (params, data) ->
      $http.post('/api/login', data)
        .then (response) -> response.data

    destroy: (params, data) ->
      $http.delete('/api/logout', data)
        .then (response) -> response.data

    verify: ->
      $http.get('/api/verify', { cache: true })
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
        super.then (user) =>
          @store('auth_token', user.auth_token_secret) if user.auth_token_secret?
          @store('user', _.pick(user, 'id', 'email'))

          return user

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
