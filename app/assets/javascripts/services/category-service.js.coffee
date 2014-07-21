angular.module('category')
  .factory 'categoryResource', ($resource) ->
    path = '/api/categories/:id'
    params = { id: '@id' }

    return $resource(path, params)

  .factory 'Category', (categoryResource, Model) ->
    class Category extends Model
      constructor: ->
        @config =
          resource: categoryResource

        super

    return Category

  .factory 'Categories', (categoryResource, Collection) ->
    class Categories extends Collection
      constructor: ->
        @config =
          resource: categoryResource

        super

    return Categories
