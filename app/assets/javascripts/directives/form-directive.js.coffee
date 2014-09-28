angular.module('form')
  .config ($provide) ->
    $provide.decorator 'ngModelDirective', ($delegate) ->
      directive = $delegate[0]
      controller = directive.controller

      directive.controller = [
        '$scope', '$element', '$attrs', '$interpolate', '$injector',
        ($scope, $element, $attrs, $interpolate, $injector) ->
          name = $interpolate($attrs.name || '')($scope)
          $attrs.$set('name', name)

          locals =
            '$scope': $scope,
            '$element': $element,
            '$attrs': $attrs

          $injector.invoke(controller, @, locals)
      ]

      return $delegate
