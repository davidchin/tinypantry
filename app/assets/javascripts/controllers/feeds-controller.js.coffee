angular.module('feed')
  .controller 'FeedsIndexController', ($scope, Feeds) ->
    class FeedsIndexController
      constructor: ->
        @feeds = new Feeds

        @read()

      read: ->
        @feeds.read()

    _.extend($scope, new FeedsIndexController)

  .controller 'FeedsNewController', ($scope, flash, Feed) ->
    class FeedsNewController
      constructor: ->
        @feed = new Feed

      submit: ->
        @feed.create()
          .then (feed) ->
            flash.set('Feed was successfully created.')
            $location.path('/feeds')

            return feed

    _.extend($scope, new FeedsNewController)

  .controller 'FeedsShowController', ($scope, $routeParams, flash, Feed) ->
    class FeedsShowController
      constructor: ->
        @feed = new Feed

        @read()

      read: ->
        @feed.read({ id: $routeParams.id })

    _.extend($scope, new FeedsShowController)

  .controller 'FeedsEditController', ($scope, $routeParams, $location, flash, Feed) ->
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

    _.extend($scope, new FeedsEditController)
