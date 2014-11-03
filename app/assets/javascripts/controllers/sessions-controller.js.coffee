angular.module('session')
  .controller 'SessionsNewController', ($scope, $state, currentUser, flash, modalStack, BaseController) ->
    class SessionsNewController extends BaseController
      constructor: ->
        @currentUser = currentUser

        @currentUser.session.verify()
          .then -> $state.go('home')

        super($scope)

      login: ->
        @currentUser.login()
          .catch (error) =>
            @catchValidationError(error, @sessionForm)

          .then ->
            flash.set('You are successfully logged in.', { type: 'success' })
            modalStack.close()

          .then =>
            $state.go('home', {}, { reload: true })
            @currentUser.password = null

            return @currentUser

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
            flash.set('You are successfully logged out.', { type: 'success' })
            $state.go('home')

            return user

    new SessionsDestroyController
