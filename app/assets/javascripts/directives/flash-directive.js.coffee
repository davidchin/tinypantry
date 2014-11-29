angular.module('flash')
  .directive 'flash', (flashFactory, $interpolate) ->
    restrict: 'EA'
    scope: true
    templateUrl: 'shared/_flash.html'
    link: (scope, element, attrs) ->
      scope.flash = flashFactory.get(attrs.name)
