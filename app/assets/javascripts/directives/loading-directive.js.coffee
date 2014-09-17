angular.module('loading')
  .directive 'loadingIndicator', ($window) ->
    restrict: 'EA'
    transclude: true
    scope:
      model: '='
    link: (scope, element, attrs, controller, transclude) ->
      class LoadingIndicator
        constructor: ->
          @configure()
          @transclude()
          @watch()

        configure: ->
          config = scope.$eval(attrs.config) || {}

          fontSize = config.size || parseFloat(element.css('font-size')) * .8
          fontColor = element.css('color')
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

          if attrs.type == 'inline'
            elementStyle =
              display: 'inline-block'
              width: width
              height: height
              position: 'relative'
              top: verticalOffset
          else
            elementStyle = {}

          element
            .css(elementStyle)
            .addClass('loading-indicator')

          @config = _.extend({}, defaultConfig, config)

        transclude: ->
          transclude (clone) ->
            element.append(clone)

        start: ->
          @spinner = new $window.Spinner(@config) unless @spinner
          @spinner.spin(element[0])
          element.show()

        stop: ->
          @spinner.stop() if @spinner
          element.hide()

        watch: ->
          scope.$watch 'model', (model) =>
            if model
              @stop()
            else
              @start()

          scope.$on '$destroy', => @stop()

          scope.$on 'start.loadingIndicator', (event, id) =>
            @start() if id == attrs.name

          scope.$on 'stop.loadingIndicator', (event, id) =>
            @stop() if id == attrs.name

      scope.loadingIndicator = new LoadingIndicator
