angular.module('analytics')
  .run ($rootScope, $location, ga) ->
    $rootScope.$on '$viewContentLoaded', ->
      ga.pageview({ page: $location.url() })

    $rootScope.$on 'modal:open', (event, modal) ->
      ga.pageview({ page: modal.href })

  .factory 'ga', ($window, $q) ->
    send: (args...) ->
      deferred = $q.defer()
      lastArg = args[-1..][0]

      options = { hitCallback: -> deferred.resolve(args) }

      _.extend(options, lastArg) if _.isObject(lastArg)

      # Modify arguments
      args = args[0..-2]
      args.push(options)
      args.unshift('send')

      $window.ga.apply($window, args)

      return deferred.promise

    pageview: (args...) ->
      @send('pageview', args...)

    event: (args...) ->
      @send('event', args...)
