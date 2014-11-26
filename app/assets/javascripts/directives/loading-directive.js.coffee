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
          config = scope.$eval(attrs.config) || {}

          fontSize = config.size || parseFloat(element.css('font-size') || 16) * .8
          fontColor = element.css('color') || 'rgb(0, 0, 0)'
          lineWidth = Math.round(fontSize / 8)
          lineLength = Math.round(fontSize / 6)
          verticalOffset = Math.round(fontSize / 8)
          radius = Math.round(fontSize / 2) + verticalOffset
          innerRadius = radius - lineWidth - lineLength
          width = radius * 2
          height = radius * 2
          lines = Math.min(Math.round(fontSize * 3 / 5), 12)

          defaultConfig =
            lines: lines
            length: lineLength
            width: lineWidth
            radius: innerRadius
            color: fontColor
            hwaccel: true

          elementStyle = {}
          elementClass = 'loading-indicator'

          if attrs.type == 'inline'
            elementStyle =
              display: 'inline-block'
              width: width
              height: height
              position: 'relative'
              top: verticalOffset

            elementClass = "#{ elementClass } loading-indicator--inline"

          element
            .css(elementStyle)
            .addClass(elementClass)

          @config = _.extend({}, defaultConfig, config)

        transclude: ->
          transclude (clone) ->
            element.append(clone)

        start: ->
          element.show()
          @spinner = new $window.Spinner(@config) unless @spinner
          $timeout => @spinner.spin(element[0])

        stop: ->
          element.hide()
          $timeout => @spinner.stop() if @spinner

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
