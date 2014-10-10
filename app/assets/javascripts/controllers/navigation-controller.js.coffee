angular.module('navigation')
  .controller 'NavigationController', ($scope, currentUser, BaseController, Categories, Modal) ->
    class NavigationController extends BaseController
      constructor: ->
        @categories = new Categories
        @loginModal = new Modal({ scope: $scope })
        @currentUser = currentUser

        @read()

        super($scope)

      openLogin: ->
        @loginModal.open('login')

      closeLogin: ->
        @loginModal.close()

      read: ->
        @categories.read()
        @currentUser.read()

    new NavigationController

  .controller 'BreadcrumbsController', ($scope, breadcrumbs, BaseController) ->
    class BreadcrumbsController extends BaseController
      constructor: ->
        @breadcrumbs = breadcrumbs

        super($scope)

    new BreadcrumbsController

