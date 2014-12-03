angular.module('category')
  .controller 'CategoriesIndexController', ($scope, BaseController, Categories) ->
    class CategoriesIndexController extends BaseController
      constructor: ->
        @categories = new Categories

        @read()

        super($scope)

      read: ->
        @categories.read({ orderBy: 'id' })

    new CategoriesIndexController

  .controller 'CategoriesNewController', ($scope, $state, breadcrumbs, BaseController, Category) ->
    class CategoriesNewController extends BaseController
      constructor: ->
        @category = new Category
        @category.keywords = [{ name: '' }]

        breadcrumbs.reset()
          .add('Categories', 'categories.index')

        super($scope)

      submit: ->
        @category.create()
          .then (category) ->
            $state.go('categories.index')

            return category

    new CategoriesNewController

  .controller 'CategoriesShowController', ($scope, $stateParams, breadcrumbs, BaseController, Category) ->
    class CategoriesShowController extends BaseController
      constructor: ->
        @category = new Category

        @read()

        breadcrumbs.reset()
          .add('Categories', 'categories.index')

        super($scope)

      read: ->
        @category.read({ id: $stateParams.id })
          .then =>
            @category.keywords.push({ name: '' })
          .catch(@catchNotFoundError)

    new CategoriesShowController

  .controller 'CategoriesEditController', ($scope, $state, $stateParams, breadcrumbs, BaseController, Category) ->
    class CategoriesEditController extends BaseController
      constructor: ->
        @category = new Category

        @read()

        breadcrumbs.reset()
          .add('Categories', 'categories.index')

        super($scope)

      read: ->
        @category.read({ id: $stateParams.id })
          .then =>
            breadcrumbs.add(@category.name, 'categories.show', { id: @category.id })
            @category.keywords.push({ name: '' })
          .catch(@catchNotFoundError)

      submit: ->
        @category.update()
          .then (category) ->
            $state.go('categories.index')

            return category

      destroy: ->
        @category.destroy()
          .then (category) ->
            $state.go('categories.index')

            return category

    new CategoriesEditController
