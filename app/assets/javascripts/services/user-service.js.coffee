angular.module('user')
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

  .factory 'CurrentUser', ($q, userService, User, Session) ->
    class CurrentUser extends User
      constructor: ->
        @session = new Session

        super

      ready: ->
        if !@requests.read
          @read()
        else
          $q.when(@requests.read)

      read: ->
        return $q.reject() unless @session.token()?

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
