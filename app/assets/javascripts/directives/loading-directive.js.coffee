angular.module('loading')
  .directive 'loadingIndicator', ($window) ->
    restrict: 'EA'
    scope:
      model: '='
    link: (scope, element, attrs) ->
      Spinner = $window.Spinner
      spinner = undefined

      fontColor = element.css('color')
      fontSize = parseFloat(element.css('font-size')) * .8
      lineWidth = Math.round(fontSize / 8)
      lineLength = Math.round(fontSize / 6)
      verticalOffset = Math.round(fontSize / 10)
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

      config = _.extend({}, defaultConfig, scope.$eval(attrs.config))

      if attrs.type == 'inline'
        elementStyle =
          display: 'inline-block'
          width: width
          height: height
          position: 'relative'
          top: verticalOffset

        element.css(elementStyle)

      scope.$watch 'model', (model) ->
        if model
          spinner.stop() if spinner
          element.hide()
        else
          spinner = new Spinner(config) unless spinner
          spinner.spin(element[0])
          element.show()

      scope.$on '$destroy', ->
        spinner.stop()
