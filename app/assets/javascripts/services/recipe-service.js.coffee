angular.module('recipe')
  .factory 'recipeResource', ($resource) ->
    path = "/api/v1/recipes/:id"
    params = { id: '@id' }
    actions =
      search:
        method: 'GET'
        isArray: true
        path: "/api/v1/recipes/search"

    return $resource(path, params, actions)
