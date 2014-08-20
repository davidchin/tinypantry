angular.module('session')
  .controller 'SessionsNewController', ($scope, $location, currentUser, flash, BaseController) ->
    class SessionsNewController extends BaseController
      constructor: ->
        @currentUser = currentUser

        @currentUser.session.verify()
          .then -> $location.path('/')

        super($scope)

      login: ->
        @currentUser.login()
          .then (user) ->
            flash.set('You are successfully logged in.')
            $location.path('/') && user

    new SessionsNewController

  .controller 'SessionsDestroyController', ($scope, $location, currentUser, flash, BaseController) ->
    class SessionsDestroyController extends BaseController
      constructor: ->
        @currentUser = currentUser

        @logout()

        super($scope)

      logout: ->
        @currentUser.logout()
          .then (user) ->
            flash.set('You are successfully logged out.')
            $location.path('/') && user

    new SessionsDestroyController
