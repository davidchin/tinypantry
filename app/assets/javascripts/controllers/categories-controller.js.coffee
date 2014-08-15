angular.module('category')
  .controller 'CategoriesIndexController', ($scope, Categories) ->
    class CategoriesIndexController
      constructor: ->
        @categories = new Categories

        @read()

      read: ->
        @categories.read()

    _.extend($scope, new CategoriesIndexController)

  .controller 'CategoriesNewController', ($scope, Category) ->
    class CategoriesNewController
      constructor: ->
        @category = new Category

      submit: ->
        @category.create()
          .then (category) ->
            $location.path('/categories')

            return category

    _.extend($scope, new CategoriesNewController)

  .controller 'CategoriesShowController', ($scope, $routeParams, Category) ->
    class CategoriesShowController
      constructor: ->
        @category = new Category

        @read()

      read: ->
        @category.read({ id: $routeParams.id })
          .then =>
            @category.data.keywords.push({ name: '' })

    _.extend($scope, new CategoriesShowController)

  .controller 'CategoriesEditController', ($scope, $routeParams, $location, Category) ->
    class CategoriesEditController
      constructor: ->
        @category = new Category

        @read()

      read: ->
        @category.read({ id: $routeParams.id })
          .then =>
            @category.data.keywords.push({ name: '' })

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

    _.extend($scope, new CategoriesEditController)
