angular.module('feed')
  .controller 'FeedsIndexController', ($scope, BaseController, Feeds) ->
    class FeedsIndexController extends BaseController
      constructor: ->
        @feeds = new Feeds

        @read()

        super($scope)

      read: ->
        @feeds.read()

    new FeedsIndexController

  .controller 'FeedsNewController', ($scope, flash, BaseController, Feed) ->
    class FeedsNewController extends BaseController
      constructor: ->
        @feed = new Feed

        super($scope)

      submit: ->
        @feed.create()
          .then (feed) ->
            flash.set('Feed was successfully created.')
            $location.path('/feeds')

            return feed

    new FeedsNewController

  .controller 'FeedsShowController', ($scope, $routeParams, flash, BaseController, Feed) ->
    class FeedsShowController extends BaseController
      constructor: ->
        @feed = new Feed

        @read()

        super($scope)

      read: ->
        @feed.read({ id: $routeParams.id })

    new FeedsShowController

  .controller 'FeedsEditController', ($scope, $routeParams, $location, flash, BaseController, Feed) ->
    class FeedsEditController extends BaseController
      constructor: ->
        @feed = new Feed

        @read()

        super($scope)

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

    new FeedsEditController
