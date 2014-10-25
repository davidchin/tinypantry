angular.module('password')
  .controller 'PasswordsResetController', ($scope, $state, flash, modalStack, BaseController, Password) ->
    class PasswordsResetController extends BaseController
      constructor: ->
        @password = new Password

        super($scope)

      submit: ->
        @password.create()
          .then ->
            flash.set('Please check your email to reset your password.', { type: 'success' })
            modalStack.close()

          .then =>
            $state.go('home', {}, { reload: true })

            return @password

          .catch (error) =>
            @catchValidationError(error, @passwordResetForm)

    new PasswordsResetController

  .controller 'PasswordsEditController', ($scope, $state, $stateParams, flash, BaseController, Password) ->
    class PasswordsEditController extends BaseController
      constructor: ->
        @password = new Password
        @password.attr('resetPasswordToken', $stateParams.reset_password_token)

        super($scope)

      submit: ->
        data = _.pick(@password, 'resetPasswordToken', 'password', 'passwordConfirmation')

        @password.update({}, data)
          .catch (error) =>
            @catchValidationError(error, @passwordEditForm)

          .then =>
            @user.login()

          .then (response) ->
            flash.set('Your password was successfully updated.', { type: 'success' })

            $state.go('home')

            return response

    new PasswordsEditController
