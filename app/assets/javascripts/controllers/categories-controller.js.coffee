angular.module('category')
  .controller 'CategoriesIndexController', ($scope, BaseController, Categories) ->
    class CategoriesIndexController extends BaseController
      constructor: ->
        @categories = new Categories

        @read()

        super($scope)

      read: ->
        @categories.read()

    new CategoriesIndexController

  .controller 'CategoriesNewController', ($scope, $state, BaseController, Category) ->
    class CategoriesNewController extends BaseController
      constructor: ->
        @category = new Category

        super($scope)

      submit: ->
        @category.create()
          .then (category) ->
            $state.go('categories.index')

            return category

    new CategoriesNewController

  .controller 'CategoriesShowController', ($scope, $state, BaseController, Category) ->
    class CategoriesShowController extends BaseController
      constructor: ->
        @category = new Category

        @read()

        super($scope)

      read: ->
        @category.read({ id: $state.params.id })
          .then =>
            @category.keywords.push({ name: '' })

    new CategoriesShowController

  .controller 'CategoriesEditController', ($scope, $state, BaseController, Category) ->
    class CategoriesEditController extends BaseController
      constructor: ->
        @category = new Category

        @read()

        super($scope)

      read: ->
        @category.read({ id: $state.params.id })
          .then =>
            @category.keywords.push({ name: '' })

      submit: ->
        @category.update()
          .then (category) ->
            $state.go('categories.index')

            return category

      destroy: ->
        @category.destroy
          .then (category) ->
            $state.go('categories.index')

            return category

    new CategoriesEditController
