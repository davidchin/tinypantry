angular.module('config')
  .controller 'HeadController', ($scope, head, BaseController) ->
    class HeadController extends BaseController
      constructor: ->
        @head = head

        super($scope)

    new HeadController
