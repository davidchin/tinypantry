angular.module('category')
  .controller 'CategoriesIndexController', (Categories) ->
    class CategoriesIndexController
      constructor: ->
        @categories = new Categories

        @read()

      read: ->
        @categories.read()

    return new CategoriesIndexController

  .controller 'CategoriesNewController', (Category) ->
    class CategoriesNewController
      constructor: ->
        @category = new Category

      submit: ->
        @category.create()
          .then (category) ->
            $location.path('/categories')

            return category

    return new CategoriesNewController

  .controller 'CategoriesShowController', ($routeParams, Category) ->
    class CategoriesShowController
      constructor: ->
        @category = new Category

        @read()

      read: ->
        @category.read({ id: $routeParams.id })

    return new CategoriesShowController

  .controller 'CategoriesEditController', ($routeParams, Category) ->
    class CategoriesEditController
      constructor: ->
        @category = new Category

        @read()

      read: ->
        @category.read({ id: $routeParams.id })

      submit: ->
        @category.update()
          .then (category) ->
            $location.path('/categories')

            return category

      destroy: ->
        @category.destroy
          .then (category) ->
            $location.path('/categories')

            return category

    return new CategoriesEditController
