angular.module('analytics')
  .run ($rootScope, $location) ->
    $rootScope.$on '$viewContentLoaded', ->
      ga('send', 'pageview', { page: $location.path() })
