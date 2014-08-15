angular.module('bookmark')
  .controller 'BookmarksIndexController', ($scope, currentUser, Bookmarks) ->
    class BookmarksIndexController
      constructor: ->
        @user = currentUser
        @bookmarks = @user.bookmarks

        @read()

      read: ->
        @user.ready()
          .then => @bookmarks.recipes()

    _.extend($scope, new BookmarksIndexController)
