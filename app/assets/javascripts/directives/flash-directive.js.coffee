angular.module('flash')
  .directive 'flash', (flashFactory, $interpolate) ->
    restrict: 'EA'
    scope: true
    link: (scope, element, attrs) ->
      class FlashDirective
        constructor: ->
          @name = attrs.name || 'app'
          @flash = flashFactory.get(@name)

      return new FlashDirective
