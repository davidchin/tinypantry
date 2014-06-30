angular.module('session')
  .controller 'SessionsNewController', ($scope, $location, currentUser) ->
    view =
      login: ->
        currentUser.login()
          .then ->
            $location.path('/')

      logout: ->
        currentUser.logout()
          .then ->
            $location.path('/')

    $scope.user = currentUser
    $scope.view = view
