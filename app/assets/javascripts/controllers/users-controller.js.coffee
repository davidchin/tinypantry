angular.module('user')
  .controller 'UsersNewController', ($scope, $state, flash, currentUser, modalStack, BaseController) ->
    class UsersNewController extends BaseController
      constructor: ->
        @user = currentUser

        super($scope)

      signUp: ->
        @user.create()
          .then => @user.login()
          .then (user) ->
            flash.set('You are successfully signed up.')

            modalStack.close()
              .then -> $state.go('home', {}, { reload: true })

            return user

    new UsersNewController

  .controller 'UsersEditController', ($scope, $state, $stateParams, flash, currentUser, BaseController) ->
    class UsersEditController extends BaseController
      constructor: ->
        @user = currentUser

        @read()

        super($scope)

      read: ->
        @user.read({ id: $stateParams.id })
          .catch(catchNotFoundError)

      submit: ->
        @user.update()
          .then (user) ->
            flash.set('User was successfully updated.')
            $state.go('home')

            return user

    new UsersEditController
