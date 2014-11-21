angular.module('seo')
  .directive 'headTitle', (head) ->
    restrict: 'A'
    scope: true
    link: (scope, element, attrs) ->
      defaultValue = element.text()
      scope.head = head

      # Watch key-value change
      scope.$watch 'head.title', (title) ->
        element.text(title || defaultValue)

  .directive 'headDescription', (head) ->
    restrict: 'A'
    scope: true
    link: (scope, element, attrs) ->
      defaultValue = attrs.content
      scope.head = head

      # Watch key-value change
      scope.$watch 'head.description', (description) ->
        attrs.$set('content', description || defaultValue)
