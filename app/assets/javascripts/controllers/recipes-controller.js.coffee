angular.module('recipe')
  .controller 'RecipesIndexController', ($scope, $state, $stateParams, $q, currentUser, flash, BaseController, Recipes, Modal) ->
    class RecipesIndexController extends BaseController
      constructor: ->
        @recipes = new Recipes
        @recipeModal = new Modal({ scope: $scope })
        @currentUser = currentUser

        @read()

        super($scope)

      search: ->
        $state.go('recipes.index', { query: @recipes.query })

      openRecipe: (recipe, event) ->
        event.preventDefault() if event?
        @recipeModal.open('recipe', { id: recipe.id })

      closeRecipe: ->
        @recipeModal.close()

      read: (params, append) ->
        params = _.defaults({}, params, $stateParams)
        method = if append then 'append' else 'read'

        @recipes[method](params)
          .then => @bookmarked()
          .then => @recipes.data()

      next: (params) ->
        params = _.defaults({ page: @recipes.pagination.nextPage }, params)

        @read(params, true) if params.page

      orderBy: (key) ->
        $state.go('recipes.index', { orderBy: key })

      bookmarked: ->
        currentUser.ready()
          .then => $q.all(@recipes.invoke('bookmarked', currentUser))

      approve: ->
        return $q.reject() unless $scope.recipesForm

        parseId = (control) ->
          parseInt(/\d+$/.exec(control.$name), 10)

        promises = (@recipes.find({ id: parseId(control) })?.update() \
          for attr, control of $scope.recipesForm \
          when control.$dirty)

        promises.push($q.reject(error: 'Please select a recipe.')) unless _.any(promises)

        $q.all(promises)
          .then ->
            flash.set('Recipe was successfully updated.', { requests: 0, type: 'success' })
          .catch (response) ->
            flash.set(response.error, { requests: 0, type: 'alert' })

    new RecipesIndexController

  .controller 'RecipesShowController', ($scope, $state, $stateParams, $q, currentUser, flash, ga, breadcrumbs, BaseController, Recipe) ->
    class RecipesShowController extends BaseController
      constructor: ->
        @currentUser = currentUser
        @recipe = new Recipe

        @read()

        breadcrumbs.reset()
          .add('Recipes', 'recipes.index')

        super($scope)

      read: ->
        @recipe.read($stateParams)
          .then =>
            @recipe.related()
          .then =>
            currentUser.ready()
              .then => @recipe.bookmarked(currentUser)
          .then => @recipe.data()
          .catch(@catchNotFoundError)

      bookmark: ->
        currentUser.ready()
          .then => currentUser.bookmarks.create({ recipeId: @recipe.id })
          .then =>
            flash.set('Recipe was successfully bookmarked.', { requests: 0, type: 'success' })

            @recipe.status.bookmarked = true
            @read()

      destroyBookmark: ->
        currentUser.ready()
          .then => currentUser.bookmarks.destroy({ id: @recipe.bookmark?.id })
          .then =>
            flash.set('Bookmark was successfully removed.', { requests: 0, type: 'success' })

            @recipe.status.bookmarked = false
            @read()

    new RecipesShowController

  .controller 'RecipesEditController', ($scope, $state, $stateParams, flash, breadcrumbs, BaseController, Recipe) ->
    class RecipesEditController extends BaseController
      constructor: ->
        @recipe = new Recipe

        @read()

        breadcrumbs.reset()
          .add('Recipes', 'recipes.index')

        super($scope)

      read: ->
        @recipe.read({ id: $stateParams.id })
          .then => breadcrumbs.add(@recipe.name, 'recipes.show', { id: @recipe.id })
          .catch(@catchNotFoundError)

      submit: ->
        @recipe.update()
          .then (recipe) ->
            flash.set('Recipe was successfully updated.')
            $state.go('recipes.index')

            return recipe

      destroy: ->
        @recipe.destroy
          .then (recipe) ->
            flash.set('Recipe was successfully destroyed.')
            $state.go('recipes.index')

            return recipe

    new RecipesEditController
