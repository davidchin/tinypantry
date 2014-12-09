angular.module('asset')
  .run ($rootScope, $window, $timeout) ->
    $rootScope.$on 'pageload:ready', ->
      $timeout -> $($window).trigger('scroll')

    $rootScope.$on 'modal:open', ->
      $timeout -> $($window).trigger('scroll')

  .config ($provide) ->
    $provide.decorator 'ngSrcDirective', ($delegate, $animate, $timeout) ->
      directive = $delegate[0]
      link = directive.link

      directive.compile = ->
        (scope, element, attrs) ->
          if !attrs.hasOwnProperty('lazyload') || attrs.lazyload == 'false'
            return link.apply(null, arguments)

          setPreloadSize = ->
            return unless attrs.preloadSize || element.css('height')

            # Determine preload width/height ratio
            regexpMatch = attrs.preloadSize.match(/(\d+)x(\d+)/)
            size = { width: regexpMatch[1], height: regexpMatch[2] }
            ratio = parseInt(size.width, 10) / parseInt(size.height, 10)

            # Determine element height
            elementWidth = element.parent().width() || 0
            elementHeight = elementWidth * ratio

            attrs.$set('height', elementHeight) if elementHeight > 0

            return elementHeight

          lazyloadImage = (src) ->
            return if !src

            # Set data attribute for lazyloading
            attrs.$set('data-src', src)

            # Add 'loading' class
            $animate.addClass(element, 'image--is-loading')

            # Set preload size
            preloadSize = setPreloadSize()
            $timeout -> preloadSize = setPreloadSize()

            # Init lazyload
            element.unveil 100, ->
              $(this).load ->
                scope.$evalAsync ->
                  $animate.removeClass(element, 'image--is-loading')
                    .then -> attrs.$set('height', null) if preloadSize

          # Observe src
          attrs.$observe 'ngSrc', lazyloadImage

      return $delegate

  .directive 'gravatarImg', ($http) ->
    restrict: 'EA'
    scope:
      gravatarId: '=id'
    link: (scope, element, attrs) ->
      img = $('<img>')

      scope.$watch 'gravatarId', (gravatarId) ->
        return unless gravatarId

        img.on 'error', (error) ->
          html = '<div class="gravatar-placeholder"><i class="fa fa-user"></i></div>'
          element.html(html)

        img.on 'load', ->
          element.html(img)

        img.attr('src', "http://www.gravatar.com/avatar/#{ gravatarId }?d=404")
