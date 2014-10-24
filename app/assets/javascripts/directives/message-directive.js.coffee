angular.module('message')
  .config ($provide) ->
    $provide.decorator 'ngMessagesDirective', ($delegate, $animate) ->
      directive = $delegate[0]
      link = directive.link

      directive.scope = true

      directive.compile = ->
        (scope, element, attrs) ->
          if attrs.errorFor
            # Determine which attribute to watch for
            if attrs.hasOwnProperty('ngMessages')
              watchAttrName = 'ngMessages'
            else
              watchAttrName = 'for'

            attrs.$set(watchAttrName, [attrs.errorFor, '$error'].join('.'))

            # Watch when ng-messages should be visible
            visibleExp = "#{ attrs.errorFor }.$invalid && " +
                         "#{ attrs.errorFor }.$dirty && " +
                         "#{ attrs.errorFor }.$touched"

            scope.$watch visibleExp, (visible) ->
              method = if visible then 'removeClass' else 'addClass'
              $animate[method](element, 'ng-hide')

            scope.$watch "#{ attrs.errorFor }.$remoteError", (errors) ->
              scope.$remoteError = errors

          # Call super method
          link.apply(@, arguments)

      return $delegate
