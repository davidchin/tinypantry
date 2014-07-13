angular.module('utility')
  .filter 'htmlSafe', ($sce) ->
    (value) -> $sce.trustAsHtml(value)
