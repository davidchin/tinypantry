angular.module('touch')
  .run ($document, $timeout, fastClick) ->
    $timeout -> fastClick.attach($document.prop('body'))

  .factory 'fastClick', ($window) ->
    $window.FastClick
