angular.module('user')
  .factory 'userService', ($resource) ->
    path = '/api/v1/users/:id'
    params = { id: '@id' }

    return $resource(path, params)

  .factory 'User', (Model) ->
    class User extends Model

    return User

  .factory 'CurrentUser', (userService, User, Session) ->
    class CurrentUser extends User
      constructor: ->
        @session = new Session

        super

      login: (email = @email, password = @password) ->
        @session.create({}, { email, password })
          .finally =>
            @password = null

      logout: ->
        @session.destroy({ auth_token: @session.token() })

    return CurrentUser

  .factory 'currentUser', ($rootScope, CurrentUser) ->
    currentUser = new CurrentUser

    $rootScope.$on '$routeChangeSuccess', ->
      currentUser.status.loggedIn = currentUser.session.token()?

    return currentUser
