angular.module('session')
  .controller 'SessionsNewController', ($scope, $location, currentUser, flash) ->
    class SessionsNewController
      constructor: ->
        @currentUser = currentUser

        @currentUser.session.verify()
          .then -> $location.path('/')

      login: ->
        @currentUser.login()
          .then (user) ->
            flash.set('You are successfully logged in.')
            $location.path('/') && user

    _.extend($scope, new SessionsNewController)

  .controller 'SessionsDestroyController', ($scope, $location, currentUser, flash) ->
    class SessionsDestroyController
      constructor: ->
        @currentUser = currentUser

        @logout()

      logout: ->
        @currentUser.logout()
          .then (user) ->
            flash.set('You are successfully logged out.')
            $location.path('/') && user

    _.extend($scope, new SessionsDestroyController)
