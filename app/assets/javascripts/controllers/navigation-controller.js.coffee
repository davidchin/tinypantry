NavigationController = (categoryResource) ->
  categoryResource.index().$promise
    .then (response) ->
      console.log(response)

# Register controller
angular.module('navigation')
  .controller('NavigationController', NavigationController)
