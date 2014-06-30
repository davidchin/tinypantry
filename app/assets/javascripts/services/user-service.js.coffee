angular.module('user')
  .factory 'userService', ($resource) ->
    path = '/api/v1/users/:id'
    params = { id: '@id' }

    return $resource(path, params)

  .factory 'User', (Model) ->
    class User extends Model

    return User

  .factory 'currentUser', ($cookies, userService, User, Session) ->
    class CurrentUser extends User
      constructor: ->
        @session = new Session

        super

      login: (email = @email, password = @password) ->
        @session.create({}, { email, password })

      logout: ->
        @session.destroy()

    user = new CurrentUser

    return user
