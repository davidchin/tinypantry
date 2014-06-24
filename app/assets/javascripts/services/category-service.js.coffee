categoryResource = ($resource) ->
  path = '/api/v1/categories/:id'
  params = { id: '@id' }

  return $resource(path, params)

# Register service
angular.module('category')
  .factory('categoryResource', categoryResource)
