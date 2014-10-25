angular.module('password')
  .factory 'passwordService', ($http) ->
    create: (params, data) ->
      $http.post('/api/password', data)
        .then (response) -> response.data

    update: (params, data) ->
      $http.put('/api/password', data)
        .then (response) -> response.data

  .factory 'Password', (passwordService, Model) ->
    class Password extends Model
      constructor: (config) ->
        @configure(resource: passwordService)

        super

  .factory 'assertPasswordResetToken', ($q, $state, $timeout, flash) ->
    (token) ->
      unless token
        $timeout ->
          flash.set('You can\'t access this page without coming from a password reset email.', { type: 'alert' })
          $state.go('home', {}, { location: 'replace' })

        return $q.reject('Unauthorized')
