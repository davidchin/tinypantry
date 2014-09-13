angular.module('analytics')
  .directive 'analyticsOutbound', (ga, $window, $state, $location) ->
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
              href = if attrs.uiSref?
                $state.href(attrs.uiSref)
              else
                attrs.href

              if /^https?:\/\//.test(href)
                $window.location = href
              else
                $location.path(href)
