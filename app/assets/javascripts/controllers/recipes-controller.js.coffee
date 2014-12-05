angular.module('recipe')
  .controller 'RecipesIndexController', ($scope, $state, $stateParams, $location, $q, currentUser, flash, ga, query, BaseController, Recipes, Modal) ->
    class RecipesIndexController extends BaseController
      constructor: ->
        @recipes = new Recipes
        @recipeModal = new Modal({ scope: $scope })
        @currentUser = currentUser

        @recipes.query = $stateParams.query

        @watch()
        @read()

        super($scope)

      watch: ->
        $scope.$on 'recipe:bookmarkCreate', (event, recipe) =>
          recipe = @recipes.find({ id: recipe.id })
          recipe.bookmarksCount += 1 if recipe

        $scope.$on 'recipe:bookmarkDestroy', (event, recipe) =>
          recipe = @recipes.find({ id: recipe.id })
          recipe.bookmarksCount -= 1 if recipe

      search: ->
        $state.go('recipes.index', { query: @recipes.query })

      openRecipe: (recipe, event) ->
        event.preventDefault() if event?
        @recipeModal.open('recipe', { id: recipe.id })

      closeRecipe: ->
        @recipeModal.close()

      read: (params, append) ->
        params = _.defaults({}, params, @params, $stateParams)

        return $q.when(@recipes.data()) if angular.toJson(@params) == angular.toJson(params)

        @params = params
        method = if append then 'append' else 'read'

        @recipes[method](@params)
          .then => @bookmarked()
          .then => @recipes.data()

      next: (params) ->
        params = _.defaults({ page: @recipes.pagination.nextPage }, params)

        return unless params.page

        @read(params, true)

        # Track
        path = query.appendParams($location.url(), { page: params.page })
        ga.pageview({ page: path }) if params.page > 1

      orderBy: (key) ->
        $state.go('recipes.index', { orderBy: key })

      bookmarked: ->
        currentUser.ready()
          .then => $q.all(@recipes.invoke('bookmarked', currentUser))

      destroy: (recipe) ->
        @recipes.destroy({ id: recipe.id })
          .then ->
            flash.set('Recipe was successfully destroyed.', { requests: 0, type: 'success' })

      approve: (recipe) ->
        recipe.approved = !recipe.approved
        recipe.update()

    new RecipesIndexController

  .controller 'RecipesShowController', ($scope, $state, $stateParams, $q, currentUser, flash, ga, breadcrumbs, head, BaseController, Recipe) ->
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
            head.set(@recipe.name, @recipe.description)
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

            $scope.$emit('recipe:bookmarkCreate', @recipe)

            @recipe.status.bookmarked = true
            @read()

      destroyBookmark: ->
        currentUser.ready()
          .then => currentUser.bookmarks.destroy({ id: @recipe.bookmark?.id })
          .then =>
            flash.set('Bookmark was successfully removed.', { requests: 0, type: 'success' })

            $scope.$emit('recipe:bookmarkDestroy', @recipe)

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
          .then =>
            @recipe.keywords.push({ name: '' })
            breadcrumbs.add(@recipe.name, 'recipes.show', { id: @recipe.id })
          .catch(@catchNotFoundError)

      submit: ->
        @recipe.update()
          .then (recipe) ->
            flash.set('Recipe was successfully updated.')
            $state.go('recipes.index')

            return recipe

      destroy: ->
        @recipe.destroy()
          .then (recipe) ->
            flash.set('Recipe was successfully destroyed.')
            $state.go('recipes.index')

            return recipe

    new RecipesEditController
