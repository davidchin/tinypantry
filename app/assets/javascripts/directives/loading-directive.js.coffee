angular.module('loading')
  .directive 'loadingIndicator', ($window, $timeout) ->
    restrict: 'EA'
    transclude: true
    scope:
      model: '='
    link: (scope, element, attrs, controller, transclude) ->
      class LoadingIndicator
        constructor: ->
          $timeout =>
            @configure()
            @transclude()
            @stop()
            @watch()

        configure: ->
          computedStyle = getComputedStyle(element.get(0))
          config = scope.$eval(attrs.config) || {}
          size = Math.round(config.size || parseFloat(element.css('font-size') || 16))
          color = computedStyle && computedStyle.color || 'rgb(0, 0, 0)'
          elementClass = 'loading-indicator'
          elementStyle =
            display: 'inline-block'
            marginTop: size * -.5
            marginLeft: size * -.5
            width: size
            height: size

          spinnerHtml = "<svg width=\"#{ size }\" height=\"#{ size }\" viewBox=\"0 0 99 99\" class=\"fa-spin\">
                          <path d=\"M49.833,0.333c-1.313,0-2.609,0.066-3.896,0.167H49.5v14.841c0.111-0.001,0.221-0.008,0.333-0.008\
                                   c19.024,0,34.5,15.477,34.5,34.5c0,19.024-15.477,34.5-34.5,34.5c-19.023,0-34.5-15.477-34.5-34.5c0-0.111,0.007-0.221,0.008-0.333\
                                   h-15c0,0.111-0.008,0.221-0.008,0.333c0,27.339,22.162,49.5,49.5,49.5c27.339,0,49.5-22.161,49.5-49.5\
                                   C99.333,22.495,77.172,0.333,49.833,0.333z\"
                                style=\"fill: #{ color }\">
                         </svg>"

          element.html(spinnerHtml)
            .addClass(elementClass)
            .css(elementStyle)

        transclude: ->
          transclude (clone) ->
            element.append(clone)

        start: ->
          element.show()

        stop: ->
          element.hide()

        watch: ->
          if attrs.hasOwnProperty('model')
            scope.$watch 'model', (model) =>
              if model
                @stop()
              else
                @start()

          scope.$on '$destroy', => @stop()

          scope.$on 'loadingIndicator:start', (event, id) =>
            $timeout => @start() if id == attrs.name

          scope.$on 'loadingIndicator:stop', (event, id) =>
            $timeout => @stop() if id == attrs.name

      scope.loadingIndicator = new LoadingIndicator
