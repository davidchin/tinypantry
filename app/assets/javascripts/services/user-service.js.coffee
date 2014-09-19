angular.module('user')
  .factory 'userService', ($resource) ->
    path = '/api/users/:id'
    params = { id: '@id' }

    return $resource(path, params)

  .factory 'currentUser', (CurrentUser) ->
    user = new CurrentUser

    return user

  .factory 'User', (userService, Model, Bookmarks, BookmarkedRecipes) ->
    class User extends Model
      constructor: ->
        @configure(resource: userService)

        @bookmarks = new Bookmarks(dependency: { user: this })
        @bookmarkedRecipes = new BookmarkedRecipes(dependency: { user: this })

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
          @status.loggedIn = true

          return user

      login: (email = @email, password = @password) ->
        @session.create({}, { email, password })
          .finally =>
            @password = null

      logout: ->
        @session.destroy()
          .finally =>
            @status.loggedIn = false

      hasRole: (roleName) ->
        _.any @roles, (role) ->
          role.name?.toLowerCase == roleName?.toLowerCase

    return CurrentUser

  .factory 'authorize', ($q, $state, currentUser) ->
    authorize = (role) ->
      currentUser.ready()
        .then ->
          unless currentUser.hasRole(role)
            $state.go('home', {}, { location: 'replace' })

            return $q.reject('Unauthorized')
