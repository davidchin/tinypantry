angular.module('asset')
  .config ($provide) ->
    $provide.decorator 'ngSrcDirective', ($delegate, $animate, $timeout) ->
      directive = $delegate[0]
      link = directive.link

      directive.compile = ->
        (scope, element, attrs) ->
          if !attrs.hasOwnProperty('lazyload') || attrs.lazyload == 'false'
            return link.apply(null, arguments)

          attrs.$observe 'ngSrc', (src) ->
            return if !src

            # Set data attribute for lazyloading
            attrs.$set('data-original', src)

            # Add 'loading' class
            $animate.addClass(element, 'image--is-loading')

            # Init lazyload
            element.lazyload
              threshold: 100,
              skip_invisible: false
              load: -> $timeout -> $animate.removeClass(element, 'image--is-loading')

      return $delegate

  .directive 'preloadSize', ($timeout) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      return unless attrs.preloadSize || element.css('height')

      $timeout ->
        return if element.loaded

        # Determine preload width/height ratio
        regexpMatch = attrs.preloadSize.match(/(\d+)x(\d+)/)
        size = { width: regexpMatch[1], height: regexpMatch[2] }
        ratio = parseInt(size.width, 10) / parseInt(size.height, 10)

        elementWidth = element.parent().width() || 0
        elementHeight = elementWidth * ratio

        if elementHeight
          attrs.$set('height', elementHeight)

          element
            .on 'load', ->
              $timeout -> attrs.$set('height', null)
