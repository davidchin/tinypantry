angular.module('navigation')
  .controller 'NavigationController', ($scope, currentUser, Categories) ->
    class NavigationController
      constructor: ->
        @categories = new Categories
        @currentUser = currentUser

        @read()

      read: ->
        @categories.read()

    _.extend($scope, new NavigationController)
