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

  .controller 'FeedsNewController', ($scope, $state, flash, BaseController, Feed) ->
    class FeedsNewController extends BaseController
      constructor: ->
        @feed = new Feed

        super($scope)

      submit: ->
        @feed.create()
          .then (feed) ->
            flash.set('Feed was successfully created.')
            $state.go('feeds.index')

            return feed

    new FeedsNewController

  .controller 'FeedsShowController', ($scope, $state, flash, catchNotFoundError, BaseController, Feed) ->
    class FeedsShowController extends BaseController
      constructor: ->
        @feed = new Feed

        @read()

        super($scope)

      read: ->
        @feed.read({ id: $state.params.id })
          .catch(catchNotFoundError)

    new FeedsShowController

  .controller 'FeedsEditController', ($scope, $state, flash, catchNotFoundError, BaseController, Feed) ->
    class FeedsEditController extends BaseController
      constructor: ->
        @feed = new Feed

        @read()

        super($scope)

      read: ->
        @feed.read({ id: $state.params.id })
          .catch(catchNotFoundError)

      submit: ->
        @feed.update()
          .then (feed) ->
            flash.set('Feed was successfully updated.')
            $state.go('feeds.index')

            return feed

      destroy: ->
        @feed.destroy
          .then (feed) ->
            flash.set('Feed was successfully destroyed.')
            $state.go('feeds.index')

            return feed

    new FeedsEditController
