angular.module('session')
  .controller 'SessionsNewController', ($scope, $location, $log, currentUser) ->
    controller =
      init: ->
        currentUser.session.verify()
          .then =>
            $log.debug('Already logged in')
            @redirect('/')

        return this

      login: ->
        currentUser.login()
          .then (response) ->
            $location.path('/')

            return response

      redirect: (path) ->
        $location.path(path)

    $scope.currentUser = currentUser
    $scope.controller = controller.init()

  .controller 'SessionsDestroyController', ($scope, $location, currentUser) ->
    controller =
      init: ->
        currentUser.logout()
          .then ->
            $location.path('/')

    $scope.controller = controller.init()
