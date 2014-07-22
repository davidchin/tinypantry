angular.module('category')
  .factory 'categoryResource', ($resource) ->
    path = '/api/categories/:id'
    params = { id: '@id' }

    return $resource(path, params)

  .factory 'Category', (categoryResource, Model) ->
    class Category extends Model
      constructor: ->
        @configure(resource: categoryResource)

        super

    return Category

  .factory 'Categories', (categoryResource, Collection, Category) ->
    class Categories extends Collection
      constructor: ->
        @configure {
          resource: categoryResource
          model: Category
        }

        super

    return Categories
