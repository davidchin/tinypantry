angular.module('navigation')
  .controller 'NavigationController', ($scope, currentUser) ->
    $scope.currentUser = currentUser
