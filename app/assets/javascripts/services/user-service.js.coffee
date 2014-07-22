angular.module('user')
  .factory 'userService', ($resource) ->
    path = '/api/users/:id'
    params = { id: '@id' }

    return $resource(path, params)

  .factory 'currentUser', (CurrentUser) ->
    user = new CurrentUser

    return user

  .factory 'User', (userService, Model, Bookmarks) ->
    class User extends Model
      constructor: ->
        @configure(resource: userService)

        @bookmarks = new Bookmarks(dependency: { user: this })

        super

    return User

  .factory 'CurrentUser', ($q, userService, User, Session) ->
    class CurrentUser extends User
      constructor: ->
        @session = new Session

        super

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
