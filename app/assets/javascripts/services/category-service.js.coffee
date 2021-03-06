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

      set: ->
        _.tap super, =>
          @keywordsAll = _.pluck(@keywords, 'name').join(', ')

      data: ->
        output = super

        output.keywords = _.filter output.keywords, (keyword) ->
          return true unless !keyword.id && !keyword.name

        return output

  .factory 'Categories', (categoryResource, Collection, Category) ->
    class Categories extends Collection
      constructor: ->
        @configure {
          resource: categoryResource
          model: Category
        }

        super
