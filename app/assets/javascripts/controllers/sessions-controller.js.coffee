angular.module('session')
  .controller 'SessionsNewController', ($location, currentUser) ->
    class SessionsNewController
      constructor: ->
        @currentUser = currentUser

        @currentUser.session.verify()
          .then =>
            $location.path('/')

      login: ->
        @currentUser.login()
          .then (response) ->
            $location.path('/') && response

    return new SessionsNewController

  .controller 'SessionsDestroyController', ($location, currentUser) ->
    class SessionsDestroyController
      constructor: ->
        @currentUser = currentUser

        @logout()

      logout: ->
        @currentUser.logout()
          .then (response) ->
            $location.path('/') && response

    return new SessionsDestroyController
