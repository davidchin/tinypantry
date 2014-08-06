angular.module('analytics')
  .directive 'analyticsOutbound', (ga, $window, $location) ->
    restrict: 'A'
    scope:
      data: '=analyticsOutbound'
    link: (scope, element, attrs) ->
      element.on 'click', (event) ->
        scope.$apply ->
          { category, action, label } = scope.data

          promise = ga.event(category, action, label)

          # Delay page change if not opening a new window
          if attrs.target != '_blank'
            event.preventDefault()

            promise.then ->
              if /^https?:\/\//.test(attrs.href)
                $window.location = attrs.href
              else
                $location.path(attrs.href)
