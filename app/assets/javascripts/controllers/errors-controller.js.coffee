angular.module('error')
  .controller 'ErrorsController', ($scope, $state, BaseController) ->
    class ErrorsController extends BaseController
      constructor: ->
        @state = $state.current

    new ErrorsController
