angular.module('modal')
  .provider 'Modal', ->
    routes: {},

    when: (name, config) ->
      @routes[name] = _.extend({}, config)

    find: (name) ->
      @routes[name]

    $get: ($rootScope, $controller, $compile, $q, $http, $animate, $templateCache, $document, modalStack, modalBackground, loadingIndicatorManager) ->
      provider = this

      class Modal
        constructor: (config) ->
          @config = _.extend {
            body: $document.prop('body')
            parent: $document.prop('body')
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
          if modalStack.has(this)
            return @close()
              .then => @open(name, params)

          _.defaults(@config, provider.find(name))

          loadingIndicatorManager.start('app')

          @getTemplate()
            .then (template) =>
              lastElement = modalStack.last()?.element
              parentElement = angular.element(@config.parent)

              @scope = @config.scope.$new() || $rootScope.$new()
              @element = angular.element(template)

              # Loading indicator
              loadingIndicatorManager.stop('app')

              # Controller
              if @config.controller
                locals = { $scope: @scope, $stateParams: params }
                controller = $controller(@config.controller, locals)
                @scope[@config.controllerAs] = controller if @config.controllerAs

              # Compile
              $compile(@element)(@scope)

              # Add to stack
              modalStack.push(this)

              # Attach background
              modalBackground.enter(parentElement)

              # Watch
              @watch()

              # Attach
              $animate.addClass(@config.body, 'modal-body--is-opened')
              $animate.enter(@element, parentElement, lastElement)

        close: ->
          return $q.when() unless modalStack.has(this)

          # Detach background
          modalBackground.leave()

          # Remove
          $animate.removeClass(@config.body, 'modal-body--is-opened')
          $animate.leave(@element)
            .then =>
              # Clean up
              @scope?.$destroy()

              # Remove from stack
              modalStack.remove(this)

              delete @element
              delete @scope

        show: ->
          $animate.removeClass(@element, 'ng-hide') if @element

        hide: ->
          $animate.addClass(@element, 'ng-hide') if @element

        watch: ->
          $rootScope.$on '$stateChangeStart', => @close()
          @scope?.$on 'modalBackground:click', => @close()

  .factory 'modalBackground', ($rootScope, $animate, $timeout) ->
    class ModalBackground
      constructor: ->
        html = '<div class="modal-overlay"></div>'
        @element = angular.element(html)

      notify: (event, args...) ->
        $rootScope.$broadcast("modalBackground:#{ event }", args...)

      enter: (parent) ->
        $animate.enter(@element, parent)

        @element.on 'click', =>
          $timeout => @notify('click')

      leave: ->
        $animate.leave(@element)

    return new ModalBackground

  .factory 'modalStack', ->
    class ModalStack
      constructor: ->
        @modals = []

      push: (modal) ->
        item.hide() for item in @modals

        @modals.splice(@index(modal), 1) if @has(modal)
        @modals.push(modal)

      remove: (modal) ->
        index = @index(modal)

        @modals.splice(index, 1) if index != -1
        @last()?.show()

      index: (modal) ->
        @modals.indexOf(modal)

      has: (modal) ->
        modal in @modals

      last: ->
        @modals[@modals.length - 1]


    return new ModalStack
