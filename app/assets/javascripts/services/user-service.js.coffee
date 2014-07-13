angular.module('user')
  .factory 'userService', ($resource) ->
    path = '/api/v1/users/:id'
    params = { id: '@id' }

    return $resource(path, params)

  .factory 'User', (userService, Model) ->
    class User extends Model
      constructor: (config) ->
        @config =
          resource: userService

        super

    return User

  .factory 'CurrentUser', (userService, User, Session) ->
    class CurrentUser extends User
      constructor: ->
        @session = new Session

        super

      read: ->
        params = { id: @retrieve('user').id }

        super(params).then (response) =>
          @status.loggedIn = true && response

      login: (email = @data.email, password = @data.password) ->
        @session.create({}, { email, password })
          .finally =>
            @password = null

      logout: ->
        @session.destroy()
          .finally =>
            @status.loggedIn = false

    return CurrentUser

  .factory 'currentUser', ($rootScope, $location, CurrentUser) ->
    currentUser = new CurrentUser

    $rootScope.$on '$routeChangeSuccess', ->
      if currentUser.session.token()? && $location.path() != '/logout'
        currentUser.read()

    return currentUser

