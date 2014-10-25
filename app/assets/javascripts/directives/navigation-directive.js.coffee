angular.module('navigation')
  .config ($provide) ->
    $provide.decorator 'headroomDirective', ($delegate) ->
      directive = $delegate[0]
      link = directive.link

      directive.compile = ->
        (scope, element) ->
          link.apply(@, arguments)

          defaults = {
            position: element.css('position')
            top: element.css('top')
          }

          scope.$on 'slideMenuGroup:openStart', ->
            top = element.offset().top

            element.css {
              position: 'absolute'
              top: top
            }

          scope.$on 'slideMenuGroup:closeEnd', ->
            element.css(defaults)

      return $delegate

  .directive 'slideMenuGroup', ($animate, $q) ->
    restrict: 'EA'

    controller: ($scope, $element) ->
      class SlideMenuGroup
        constructor: ->
          @menus = []

        setContent: (content) ->
          @content = content

          return this

        add: (menu) ->
          @menus.push(menu) unless @has(menu)

          return this

        remove: (menu) ->
          index = @menus.indexOf(menu)

          @menus.splice(index, 1) if index != -1

          return this

        has: (menu) ->
          menu in @menus

        toggle: (menu, active) ->
          menu = _.find(@menus, { id: menu }) if _.isString(menu)

          # Guard statement
          return unless menu? and @content?

          # Toggle active state unless active state is defined
          active = !menu.active unless active?

          if active
            @activeMenu = menu
            @activeMenu.open()
            @content.open(@activeMenu.id)

            # Close all
            menu.close() for menu in @menus when menu != @activeMenu

            # Add Class
            $scope.$broadcast('slideMenuGroup:openStart')

            $q.all([
              $animate.addClass($element, 'is-opened')
              $animate.removeClass($element, 'is-closed')
            ]).then ->
              $scope.$broadcast('slideMenuGroup:openEnd')
          else
            menu.close()
            @content.close(menu.id)

            # Reset
            @activeMenu = undefined if @activeMenu == menu

            # Remove Class
            $scope.$broadcast('slideMenuGroup:closeStart')

            $q.all([
              $animate.addClass($element, 'is-closed')
              $animate.removeClass($element, 'is-opened')
            ]).then ->
              $scope.$broadcast('slideMenuGroup:closeEnd')

          return this

        open: (menu) ->
          @toggle(menu, true)

        close: (menu) ->
          @toggle(menu, false)

      # Extend controller
      slideMenuGroup = new SlideMenuGroup

      @[key] = slideMenuGroup[key] for key of slideMenuGroup

  .directive 'slideMenuToggle', ->
    restrict: 'EA'
    scope: {}
    transclude: true
    replace: true
    require: '^slideMenuGroup'

    template: (element, attrs) ->
      tagName = element.prop('tagName').toLowerCase()
      tagName = 'button' if tagName == 'slide-menu-toggle'

      template = "<#{ tagName } ng-click=';slideMenuToggle.toggle();' ng-transclude>"
      tag = angular.element(template)

      tag.prop('outerHTML')

    link: (scope, element, attrs, slideMenuGroup) ->
      class SlideMenuToggle
        constructor: ->
          @group = slideMenuGroup
          @targetId = attrs.slideMenuToggle || attrs.targetId

        toggle: ->
          @group.toggle(@targetId || @group.activeMenu)

          return this

      scope.slideMenuToggle = new SlideMenuToggle

  .directive 'slideMenu', ($animate) ->
    restrict: 'EA'
    require: '^slideMenuGroup'

    link: (scope, element, attrs, slideMenuGroup) ->
      class SlideMenu
        constructor: ->
          @group = slideMenuGroup
          @id = attrs.slideMenu || attrs.id

          element.addClass(@id)

          @watch()
          @close()
          @group.add(this)

        watch: ->
          scope.$on '$destroy', =>
            @group.remove(this)

        toggle: (active) ->
          active = !@active unless active?

          # Flag
          @active = active

          # Add/remove class
          if active
            $animate.addClass(element, 'is-opened')
            $animate.removeClass(element, 'is-closed')
          else
            $animate.addClass(element, 'is-closed')
            $animate.removeClass(element, 'is-opened')

          return this

        open: ->
          @toggle(true)

        close: ->
          @toggle(false)

      new SlideMenu

  .directive 'slideMenuContent', ($animate, $timeout, $compile) ->
    restrict: 'EA'
    require: '^slideMenuGroup'

    link: (scope, element, attrs, slideMenuGroup) ->
      class SlideMenuContent
        constructor: ->
          element.addClass('slide-menu-content')

          @group = slideMenuGroup

          @watch()
          @close()
          @group.setContent(this)

        watch: ->
          scope.$on '$destroy', =>
            @group.setContent(null)

        block: ->
          unless @blocker?
            @blocker = angular.element('<slide-menu-toggle>')
            
            @blocker.css {
              display: 'block'
              position: 'fixed'
              top: 0
              right: 0
              bottom: 0
              left: 0
              cursor: 'default'
              width: '100%'
            }

            element.append(@blocker)

            $compile(@blocker)(scope)
          else
            element.append(@blocker)

        unblock: ->
          @blocker.detach() if @blocker?

        toggle: (id, active) ->
          return unless id?

          active = !@active unless active?

          # Flag
          @active = active

          # Add/remove class
          if active
            $animate.addClass(element, "is-opened #{ id }-is-opened")
            $animate.removeClass(element, "is-closed #{ id }-is-closed")

            # Block interaction
            @block()
          else
            $animate.addClass(element, "is-closed #{ id }-is-closed")
            $animate.removeClass(element, "is-opened #{ id }-is-opened")

            # Unblock interaction
            @unblock()

          return this

        open: (id) ->
          @toggle(id, true)

        close: (id) ->
          @toggle(id, false)

      new SlideMenuContent