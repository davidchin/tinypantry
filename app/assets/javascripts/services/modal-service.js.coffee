angular.module('modal')
  .provider 'Modal', ->
    routes: {},

    when: (name, config) ->
      @routes[name] = _.extend({}, config)

      return this

    find: (name) ->
      @routes[name]

    $get: ($rootScope, $controller, $compile, $q, $http, $animate, $templateCache, $document, $timeout, $state, modalStack, modalBackground, loadingIndicatorManager) ->
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

        configure: (name) ->
          # Set config
          _.defaults(@config, { name }, provider.find(name))

          # Set undefined
          @config.controller = $state.get(@config.state)?.controller unless @config.controller

          return @config

        open: (name, params) ->
          if modalStack.has(this)
            return @close()
              .then => @open(name, params)

          # Configure
          @configure(name)

          # Determine equivalent href
          @href = $state.href(@config.state, params) if @config.state

          # Start loading indicator
          loadingIndicatorManager.start('app')

          # Get HTML template
          @getTemplate()
            .then (template) =>
              lastElement = modalStack.last()?.element
              parentElement = angular.element(@config.parent)

              @scope = @config.scope.$new() || $rootScope.$new()
              @element = angular.element(template)

              # Loading indicator
              loadingIndicatorManager.stop('app')

              # Add to stack
              modalStack.push(this)

              # Controller
              if @config.controller
                locals = { $scope: @scope, $stateParams: params }
                controller = $controller(@config.controller, locals)
                @scope[@config.controllerAs] = controller if @config.controllerAs

              # Compile
              $compile(@element)(@scope)

              # Watch
              @watch()

              # Attach background
              modalBackground.enter(parentElement)

              $timeout =>
                # Attach
                $animate.addClass(@config.body, 'modal-body--is-opened')
                $animate.enter(@element, parentElement, lastElement)
                  .then =>
                    # Notify
                    $timeout => @notify('open', this)
              , 300


        close: ->
          return $q.when() unless modalStack.has(this)

          # Detach background
          modalBackground.leave()

          # Remove from stack
          modalStack.remove(this)

          # Remove from DOM
          $animate.removeClass(@config.body, 'modal-body--is-opened')
          $animate.leave(@element)
            .then =>
              # Clean up
              @scope?.$destroy()

              delete @element
              delete @scope

              # Notify
              $timeout =>
                @notify('close', this)

        show: ->
          $animate.removeClass(@element, 'ng-hide') if @element

        hide: ->
          $animate.addClass(@element, 'ng-hide') if @element

        watch: ->
          $rootScope.$on '$stateChangeStart', => @close()
          @scope?.$on 'modalBackground:click', => @close()

        notify: (event, args...) ->
          $rootScope.$broadcast("modal:#{ event }", args...)

  .factory 'modalBackground', ($rootScope, $animate, $timeout) ->
    class ModalBackground
      constructor: ->
        html = '<div class="modal-overlay"></div>'
        @element = angular.element(html)

      notify: (event, args...) ->
        $rootScope.$broadcast("modalBackground:#{ event }", args...)

      enter: (parent) ->
        @element.on 'click', =>
          $timeout => @notify('click', this)

        $animate.enter(@element, parent)

      leave: ->
        $animate.leave(@element)

    return new ModalBackground

  .factory 'modalStack', ($q) ->
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

      is: (name) ->
        @current()?.config.name == name

      last: ->
        @modals[@modals.length - 1]

      current: ->
        @last.apply(@, arguments)

      close: ->
        modal = @current()

        if modal?
          modal.close()
        else
          $q.when()

    return new ModalStack
