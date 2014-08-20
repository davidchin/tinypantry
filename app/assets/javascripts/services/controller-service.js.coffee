angular.module('controller')
  .factory 'BaseController', ->
    class BaseController
      constructor: (scope) ->
        scope[key] = @[key] for key of @
