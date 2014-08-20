angular.module('navigation')
  .controller 'NavigationController', ($scope, currentUser, BaseController, Categories) ->
    class NavigationController extends BaseController
      constructor: ->
        @categories = new Categories
        @currentUser = currentUser

        @read()

        super($scope)

      read: ->
        @categories.read()

    new NavigationController
