angular.module('bookmark')
  .controller 'BookmarksIndexController', ($scope, currentUser, BaseController, Bookmarks) ->
    class BookmarksIndexController extends BaseController
      constructor: ->
        @user = currentUser
        @bookmarks = @user.bookmarks

        @read()

        super($scope)

      read: ->
        @user.ready()
          .then => @bookmarks.read()

    new BookmarksIndexController
