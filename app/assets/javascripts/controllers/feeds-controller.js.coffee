angular.module('feed')
  .controller 'FeedsIndexController', (Feeds) ->
    class FeedsIndexController
      constructor: ->
        @feeds = new Feeds

        @read()

      read: ->
        @feeds.read()

    return new FeedsIndexController

  .controller 'FeedsNewController', (flash, Feed) ->
    class FeedsNewController
      constructor: ->
        @feed = new Feed

      submit: ->
        @feed.create()
          .then (feed) ->
            flash.set('Feed was successfully created.')
            $location.path('/feeds')

            return feed

    return new FeedsNewController

  .controller 'FeedsShowController', ($routeParams, flash, Feed) ->
    class FeedsShowController
      constructor: ->
        @feed = new Feed

        @read()

      read: ->
        @feed.read({ id: $routeParams.id })

    return new FeedsShowController

  .controller 'FeedsEditController', ($routeParams, $location, flash, Feed) ->
    class FeedsEditController
      constructor: ->
        @feed = new Feed

        @read()

      read: ->
        @feed.read({ id: $routeParams.id })

      submit: ->
        @feed.update()
          .then (feed) ->
            flash.set('Feed was successfully updated.')
            $location.path('/feeds')

            return feed

      destroy: ->
        @feed.destroy
          .then (feed) ->
            flash.set('Feed was successfully destroyed.')
            $location.path('/feeds')

            return feed

    return new FeedsEditController
