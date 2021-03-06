angular.module('user')
  .config ($stateProvider, ModalProvider) ->
    $stateProvider
      .state 'users',
        url: '/users'
        abstract: true
        template: '<ui-view />'

      .state 'users.password',
        url: '/password'
        abstract: true
        template: '<ui-view />'

      .state 'users.password.reset',
        url: '/reset'
        templateUrl: 'passwords/reset.html'
        controller: 'PasswordsResetController'

      .state 'users.password.edit',
        url: '/edit?reset_password_token'
        templateUrl: 'passwords/edit.html'
        controller: 'PasswordsEditController'
        resolve:
          assertPasswordResetToken: ($stateParams, assertPasswordResetToken) ->
            assertPasswordResetToken($stateParams.reset_password_token)

      .state 'users.new',
        url: '^/sign-up'
        templateUrl: 'users/new.html'
        controller: 'UsersNewController'

      .state 'users.edit',
        url: '/:id/edit'
        templateUrl: 'users/edit.html'
        controller: 'UsersNewController'

    ModalProvider
      .when 'signUp',
        state: 'users.new'
        templateUrl: 'users/new-modal.html'

      .when 'passwordReset',
        state: 'users.password.reset'
        templateUrl: 'passwords/reset-modal.html'
