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
