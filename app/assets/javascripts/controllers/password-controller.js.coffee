angular.module('password')
  .controller 'PasswordResetController', ($scope, $state, flash, modalStack, BaseController, Password) ->
    class PasswordResetController extends BaseController
      constructor: ->
        @password = new Password

        super($scope)

      submit: ->
        @password.create()
          .then ->
            flash.set('You successfully reset your password.')
            modalStack.close()

          .then =>
            $state.go('home', {}, { reload: true })

            return @password

    new PasswordResetController
