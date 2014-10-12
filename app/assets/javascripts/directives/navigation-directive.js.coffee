angular.module('navigation')
  .directive 'slideMenuContainer', ->
    restrict: 'EA'
    scope: true
    controller: ($element) ->
      class SlideMenuContainer
        constructor: ->
          @menus = []
          @element = $element

        add: (menu) ->
          @menus.push(menu) unless @has(menu)

        remove: (menu) ->
          index = @menus.indexOf(menu)

          @menus.splice(index, 1) if index != -1

        has: (menu) ->
          menu in @menus

        toggle: (menu, active) ->
          menu = _.find(@menus, { id: menu }) if _.isString(menu)

          # Guard statement
          return unless menu?

          # Toggle active state unless active state is defined
          active = !menu.active unless active?

          if active
            @activeMenu = menu
            @activeMenu.open()

            # Close all
            menu.close() for menu in @menus when menu != @activeMenu
          else
            menu.close()

            # Reset
            @activeMenu = undefined if @activeMenu == menu

      # Extend controller
      slideMenuContainer = new SlideMenuContainer

      @[key] = slideMenuContainer[key] for key of slideMenuContainer

  .directive 'slideMenuToggle', ($rootScope) ->
    restrict: 'EA'
    scope: true
    transclude: true
    replace: true
    require: '^slideMenuContainer'
    template: (element, attrs) ->
      tagName = element.prop('tagName').toLowerCase()
      template = "<#{ tagName } ng-click='slideMenuToggle.toggle();' ng-transclude>"
      tag = angular.element(template)

      tag.prop('outerHTML')

    link: (scope, element, attrs, slideMenuContainer) ->
      class SlideMenuToggle
        constructor: ->
          @container = slideMenuContainer
          @targetId = attrs.slideMenuToggle || attrs.targetId

        toggle: ->
          @container.toggle(@targetId)

      scope.slideMenuToggle = new SlideMenuToggle

  .directive 'slideMenu', ($document, $animate) ->
    restrict: 'EA'
    scope: true
    require: '^slideMenuContainer'
    link: (scope, element, attrs, slideMenuContainer) ->
      class SlideMenu
        constructor: ->
          @body = angular.element($document.prop('body'))
          @container = slideMenuContainer
          @id = attrs.slideMenu || attrs.id

          attrs.$set('id', @id)

          @watch()
          @container.add(this)
          @container.toggle(this, false)

        watch: ->
          scope.$on '$destroy', =>
            @container.remove(this)

        toggle: (active) ->
          active = !@active unless active?

          # Flag
          @active = active

          # Add/remove class
          if active
            $animate.addClass(element, "is-opened")
            $animate.removeClass(element, "is-closed")
            $animate.addClass(@container.element, "#{ @id }--is-opened")
            $animate.removeClass(@container.element, "#{ @id }--is-closed")
          else
            $animate.addClass(element, "is-closed")
            $animate.removeClass(element, "is-opened")
            $animate.addClass(@container.element, "#{ @id }--is-closed")
            $animate.removeClass(@container.element, "#{ @id }--is-opened")

        open: ->
          @toggle(true)

        close: ->
          @toggle(false)

      scope.slideMenu = new SlideMenu
