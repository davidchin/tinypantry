angular.module('touch')
  .run ($document, $rootScope, fastClick) ->
    $rootScope.$on '$viewContentLoaded', ->
      fastClick.attach($document.prop('body'))

  .factory 'fastClick', ($window) ->
    $window.FastClick
