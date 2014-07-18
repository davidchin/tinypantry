angular.module('user')
  .run ($rootScope, $location, currentUser) ->
    $rootScope.$on '$routeChangeSuccess', ->
      if currentUser.session.token()? && $location.path() != '/logout'
        currentUser.read()

  .factory 'userService', ($resource) ->
    path = '/api/v1/users/:id'
    params = { id: '@id' }
    actions =
      bookmarks:
        method: 'GET'
        isArray: true
        url: '/api/v1/users/:id/bookmarks'

    return $resource(path, params, actions)

  .factory 'currentUser', (CurrentUser) ->
    user = new CurrentUser

    return user

  .factory 'readCurrentUser', (currentUser) ->
    currentUser.read()

  .factory 'User', (userService, Model) ->
    class User extends Model
      constructor: (config) ->
        @config =
          resource: userService

        super

      bookmarks: (params) ->
        params = _.extend({ id: @data.id }, params)

        @request('bookmarks', params)

    return User

  .factory 'CurrentUser', (userService, User, Session) ->
    class CurrentUser extends User
      constructor: ->
        @session = new Session

        super

      read: ->
        params = { id: @retrieve('user').id }

        super(params).then (user) =>
          @status.loggedIn = true && user

      login: (email = @data.email, password = @data.password) ->
        @session.create({}, { email, password })
          .finally =>
            @password = null

      logout: ->
        @session.destroy()
          .finally =>
            @status.loggedIn = false

    return CurrentUser
