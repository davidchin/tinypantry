angular.module('navigation')
  .controller 'NavigationController', ($scope, currentUser, BaseController, Categories, Recipes, Modal) ->
    class NavigationController extends BaseController
      constructor: ->
        @categories = new Categories
        @recipes = new Recipes
        @loginModal = new Modal({ scope: $scope })
        @signUpModal = new Modal({ scope: $scope })
        @currentUser = currentUser

        @read()

        super($scope)

      openLogin: (event) ->
        event.preventDefault() if event
        @loginModal.open('login')

      closeLogin: ->
        @loginModal.close()

      openSignUp: (event) ->
        event.preventDefault() if event
        @signUpModal.open('signUp')

      closeSignUp: ->
        @signUpModal.close()

      read: ->
        @categories.read()
        @recipes.read()
        @currentUser.read()

    new NavigationController

  .controller 'BreadcrumbsController', ($scope, breadcrumbs, BaseController) ->
    class BreadcrumbsController extends BaseController
      constructor: ->
        @breadcrumbs = breadcrumbs

        super($scope)

    new BreadcrumbsController

