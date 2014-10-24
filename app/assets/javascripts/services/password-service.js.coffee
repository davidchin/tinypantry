angular.module('password')
  .factory 'passwordService', ($http) ->
    reset: ->
      $http.post('/api/password')
        .then (response) -> response.data

  .factory 'Password', (passwordService, Model) ->
    class Password extends Model
      constructor: (config) ->
        @configure(resource: sessionService)

        super
