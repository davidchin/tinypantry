angular.module('session')
  .controller 'SessionsNewController', ($scope, $state, $timeout, currentUser, flash, modalStack, BaseController) ->
    class SessionsNewController extends BaseController
      constructor: ->
        @currentUser = currentUser

        @currentUser.session.verify()
          .then -> $state.go('home')

        super($scope)

      login: ->
        @currentUser.login()
          .then (user) ->
            flash.set('You are successfully logged in.')

            modalStack.close()
              .then -> $state.go('home', {}, { reload: true })

            return user

    new SessionsNewController

  .controller 'SessionsDestroyController', ($scope, $state, currentUser, flash, BaseController) ->
    class SessionsDestroyController extends BaseController
      constructor: ->
        @currentUser = currentUser

        @logout()

        super($scope)

      logout: ->
        @currentUser.logout()
          .then (user) ->
            flash.set('You are successfully logged out.')
            $state.go('home')

            return user

    new SessionsDestroyController
