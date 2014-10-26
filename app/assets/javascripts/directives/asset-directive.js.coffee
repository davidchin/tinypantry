angular.module('asset')
  .config ($provide) ->
    $provide.decorator 'ngSrcDirective', ($delegate) ->
      directive = $delegate[0]
      link = directive.link

      directive.compile = ->
        (scope, element, attrs) ->
          if !attrs.hasOwnProperty('lazyload') || attrs.lazyload == 'false'
            return link.apply(null, arguments)

          attrs.$observe 'ngSrc', (src) ->
            return if !src

            attrs.$set('data-original', src)
            element.lazyload()

      return $delegate
