angular.module('feed')
  .controller 'FeedsIndexController', (Feeds) ->
    class FeedsIndexController
      constructor: ->
        @feeds = new Feeds

        @read()

      read: ->
        @feeds.read()

    return new FeedsIndexController

  .controller 'FeedsNewController', (Feed) ->
    class FeedsNewController
      constructor: ->
        @feed = new Feed

      submit: ->
        @feed.create()
          .then (feed) ->
            $location.path('/feeds')

            return feed

    return new FeedsNewController

  .controller 'FeedsShowController', ($routeParams, Feed) ->
    class FeedsShowController
      constructor: ->
        @feed = new Feed

        @read()

      read: ->
        @feed.read({ id: $routeParams.id })

    return new FeedsShowController

  .controller 'FeedsEditController', ($routeParams, $location, Feed) ->
    class FeedsEditController
      constructor: ->
        @feed = new Feed

        @read()

      read: ->
        @feed.read({ id: $routeParams.id })

      submit: ->
        @feed.update()
          .then (feed) ->
            $location.path('/feeds')

            return feed

      destroy: ->
        @feed.destroy
          .then (feed) ->
            $location.path('/feeds')

            return feed

    return new FeedsEditController
