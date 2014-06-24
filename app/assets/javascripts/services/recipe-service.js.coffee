recipeResource = ($resource) ->
  basePath = '/api/v1/recipes'
  path = "#{ basePath }/:id"
  params = { id: '@id' }
  actions = {
    search: {
      method: 'GET',
      isArray: true,
      path: "#{ basePath }/search"
    }
  }

  return $resource(path, params, actions)

# Register service
angular.module('recipe')
  .factory('recipeResource', recipeResource)
