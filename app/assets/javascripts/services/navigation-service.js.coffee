angular.module('navigation')
  .run ($rootScope, $window, $location, $document, breadcrumbs, historyStack) ->
    $rootScope.$on '$stateChangeSuccess', ->
      breadcrumbs.reset()

    $($window).on 'popstate', ->
      scrollTop = historyStack.scrollTop($location.url()) || 0
      $document.scrollTop(scrollTop)

    $rootScope.$on '$locationChangeStart', (event, toUrl, fromUrl) ->
      historyStack.record(fromUrl)

  .factory 'breadcrumbs', ($state) ->
    class Breadcrumbs
      constructor: ->
        @items = []

      add: (name, state, stateParams) ->
        @add('Home', 'home') if @items.length == 0 && state != 'home'

        path = $state.href(state, stateParams)
        @items.push({ name, path })

        return @

      remove: (name) ->
        index = _.findIndex(@items, { name })
        @items.splice(index, 1) if index > -1

        return @

      reset: ->
        @items.length = 0

        return @

    new Breadcrumbs

  .factory 'historyStack', ($rootScope, $window, $document, $location) ->
    class HistoryStack
      constructor: ->
        @items = []

      find: (path) ->
        _.find(@items, { path: path })

      scrollTop: (url) ->
        record = @find(url)

        return record?.scrollTop

      record: (url) ->
        fromPath = _.last(url.split($window.location.host))
        index = _.findIndex(@items, { path: fromPath })

        if index >= 0
          record = @items[index]
          @items.splice(0, 1)
        else
          record = { path: fromPath }

        record.scrollTop = $document.scrollTop()
        @items.push(record)

    new HistoryStack
