angular.module('navigation')
  .controller 'NavigationController', (Categories) ->
    class NavigationController
      constructor: ->
        @categories = new Categories

        @get()

      get: ->
        @categories.read()

    return new NavigationController
