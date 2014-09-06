angular.module('analytics')
  .run ($rootScope, $location, ga) ->
    $rootScope.$on '$viewContentLoaded', ->
      ga.pageview({ page: $location.path() })

  .factory 'ga', ($window, $q) ->
    send: (args...) ->
      deferred = $q.defer()
      lastArg = args[-1..][0]

      options = { hitCallback: -> deferred.resolve(args) }

      _.extend(options, lastArg) if _.isObject(lastArg)

      $window.ga.apply($window, args[0..-2].concat([options]))

      return deferred.promise

    pageview: (args...) ->
      @send('pageview', args...)

    event: (args...) ->
      @send('event', args...)
