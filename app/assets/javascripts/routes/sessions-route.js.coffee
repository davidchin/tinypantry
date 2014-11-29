angular.module('session')
  .config ($stateProvider, ModalProvider) ->
    $stateProvider
      .state 'sessions',
        abstract: true
        template: '<ui-view />'

      .state 'sessions.new',
        url: '/login'
        templateUrl: 'sessions/new.html'
        controller: 'SessionsNewController'

      .state 'sessions.destroy',
        url: '/logout'
        templateUrl: 'sessions/destroy.html'
        controller: 'SessionsDestroyController'

    ModalProvider
      .when 'login',
        state: 'sessions.new'
        templateUrl: 'sessions/new-modal.html'
