angular.module('modal')
  .provider 'Modal', ->
    class ModalProvider
      constructor: ->
        @routes = {}

      when: (name, config) ->
        @routes[name] = _.extend({}, config)

      find: (name) ->
        @routes[name]

      $get: ($rootScope, $controller, $compile, $q, $http, $animate, $templateCache) ->
        provider = this

        class Modal
          constructor: (config) ->
            @config = _.extend {
              parent: 'body'
            }, config

          getTemplate: ->
            if @config.templateUrl
              promise = $http.get(@config.templateUrl, { cache: $templateCache })
                .then (response) -> response.data
            else
              deferred = $q.defer()
              deferred.resolve(@config.template)

              promise = deferred.promise

            return promise

          open: (name, params) ->
            return $q.when() if @element

            _.defaults(@config, provider.find(name))

            @getTemplate()
              .then (template) =>
                @scope = @config.scope.$new() || $rootScope.$new()
                @element = angular.element(template)

                # Controller
                if @config.controller
                  locals = { $scope: @scope, $routeParams: params }
                  controller = $controller(@config.controller, locals)
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
                @scope.$destroy()

                delete @element
                delete @scope

    new ModalProvider
