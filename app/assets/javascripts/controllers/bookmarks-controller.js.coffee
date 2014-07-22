angular.module('bookmark')
  .controller 'BookmarksIndexController', (currentUser, Bookmarks) ->
    class BookmarksIndexController
      constructor: ->
        @user = currentUser
        @bookmarks = @user.bookmarks

        @read()

      read: ->
        @user.ready()
          .then => @bookmarks.recipes()

    return new BookmarksIndexController
