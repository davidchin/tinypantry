angular.module('navigation')
  .controller 'NavigationController', (currentUser, Categories) ->
    class NavigationController
      constructor: ->
        @categories = new Categories
        @currentUser = currentUser

        @read()

      read: ->
        @categories.read()

    return new NavigationController
