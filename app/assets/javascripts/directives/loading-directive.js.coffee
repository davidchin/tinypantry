angular.module('loading')
  .directive 'loadingIndicator', ($window, $timeout) ->
    restrict: 'EA'
    transclude: true
    scope:
      model: '='
      config: '='
    link: (scope, element, attrs, controller, transclude) ->
      class LoadingIndicator
        constructor: ->
          $timeout =>
            @configure()
            @transclude()
            @stop()
            @watch()

        configure: ->
          elementClass = 'loading-indicator'
          elementStyle =
            display: 'inline-block'

          # Spinner icon
          spinnerHtml = "<svg viewBox=\"0 0 99 99\" class=\"fa-spin\">
                           <path d=\"M49.833,0.333c-1.313,0-2.609,0.066-3.896,0.167H49.5v14.841c0.111-0.001,0.221-0.008,0.333-0.008\
                                     c19.024,0,34.5,15.477,34.5,34.5c0,19.024-15.477,34.5-34.5,34.5c-19.023,0-34.5-15.477-34.5-34.5c0-0.111,0.007-0.221,0.008-0.333\
                                     h-15c0,0.111-0.008,0.221-0.008,0.333c0,27.339,22.162,49.5,49.5,49.5c27.339,0,49.5-22.161,49.5-49.5\
                                     C99.333,22.495,77.172,0.333,49.833,0.333z\">\
                         </svg>"
          @spinnerElement = $(spinnerHtml)
          @updateColor()
          @updateSize()

          # Append spinner icon
          element.html(@spinnerElement)
            .addClass(elementClass)
            .css(elementStyle)

        updateColor: ->
          @spinnerElement.find('path').css('fill', @computedColor())

        updateSize: ->
          size = @computedSize()

          element.css
            width: size
            height: size

          @spinnerElement.attr
            width: size
            height: size

          @spinnerElement.css
            top: size * -.5
            left: size * -.5

        computedStyle: ->
          getComputedStyle(element.get(0)) || {}

        computedColor: ->
          scope.config?.color || @computedStyle()['color'] || 'rgb(0, 0, 0)'

        computedSize: ->
          scope.config?.size || @computedStyle()['font-size'] || 16

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
