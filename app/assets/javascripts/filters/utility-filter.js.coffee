angular.module('sanitize')
  .filter 'htmlSafe', ($sce) ->
    (value) -> $sce.trustAsHtml(value)
