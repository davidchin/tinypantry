angular.module('modal')
  .factory 'Modal', ($rootScope, $controller, $compile, $q, $http, $animate, $templateCache) ->
    class Modal
      constructor: (config) ->
        defaultConfig = {
          parent: 'body'
        }

        @config = _.defaults(config, defaultConfig)

      getTemplate: ->
        if @config.templateUrl
          promise = $http.get(@config.templateUrl, { cache: $templateCache })
            .then (response) -> response.data
        else
          deferred = $q.defer()
          deferred.resolve(@config.template)

          promise = deferred.promise

        return promise

      open: ->
        return $q.when() if @element

        @getTemplate()
          .then (template) =>
            @scope = @config.scope || $rootScope.$new()
            @element = angular.element(template)

            # Controller
            if @config.controller
              controller = $controller(@config.controller, { $scope: @scope })
              @scope[@config.controllerAs] = controller if @config.controllerAs

            # Compile
            $compile(@element)(@scope)

            # Attach
            $animate.enter(@element, angular.element(@config.parent))

      close: ->
        return $q.when() unless @element

        $animate.leave(@element)
          .then =>
            # Clean up
            $scope.$destroy()

            delete @element
            delete @scope

    return Modal
