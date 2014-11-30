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

          iconHTML = '<i class="fa fa-spin fa-circle-o-notch" />'
          size = Math.round(config.size || parseFloat(element.css('font-size') || 16))
          elementClass = 'loading-indicator'
          elementStyle =
            display: 'inline-block'
            marginTop: size * -.5
            marginLeft: size * -.5
            width: size
            height: size
            fontSize: size

          element.html(iconHTML)
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
