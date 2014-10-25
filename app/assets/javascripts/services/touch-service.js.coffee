angular.module('touch')
  .run ($document, fastClick) ->
    fastClick.attach($document.prop('body'))

  .factory 'fastClick', ($window) ->
    $window.FastClick
