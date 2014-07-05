angular.module('session')
  .factory 'sessionService', ($http) ->
    create: (params, data) ->
      $http.post('/api/v1/login', data)
        .then (response) -> response.data

    destroy: (params, data) ->
      $http.delete('/api/v1/logout', data)
        .then (response) -> response.data

  .factory 'Session', ($q, sessionService, Model) ->
    class Session extends Model
      constructor: (config) ->
        @config =
          resource: sessionService

        super

      create: ->
        super.then (response) =>
          if response.auth_token_secret?
            @store('auth_token', response.auth_token_secret)

          return response

      destroy: ->
        super.finally (response) =>
          @store('auth_token', null)

      verify: ->
        auth_token = @token()

        # TODO: Make an API call to validate the current auth token
        if auth_token? then $q.when() else $q.reject()

      token: ->
        @retrieve('auth_token')

    return Session
