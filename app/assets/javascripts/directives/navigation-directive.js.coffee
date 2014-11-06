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

  .directive 'slideMenuGroup', ($animate, $q, $timeout) ->
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
          menu = @find(menu) if _.isString(menu)

          # Guard statement
          return unless menu? and @content?

          # Toggle active state unless active state is defined
          active = !menu.active unless active?

          # Get HTML reference
          html = $('html')

          if active
            @activeMenu = menu
            @activeMenu.open()
            @content.open(@activeMenu.id)

            # Close all
            menu.close() for menu in @menus when menu != @activeMenu

            # Broadcast event
            $scope.$broadcast('slideMenuGroup:openStart', @activeMenu)

            # Add Class
            $q.all([
              $animate.addClass($element, 'is-slide-menu-opened')
              $animate.removeClass($element, 'is-slide-menu-closed')
              $animate.addClass(html, 'is-slide-menu-opened')
              $animate.removeClass(html, 'is-slide-menu-closed')
            ]).then ->
              $scope.$broadcast('slideMenuGroup:openEnd', @activeMenu)

          else
            menu.close()
            @content.close(menu.id)

            # Reset
            @activeMenu = undefined if @activeMenu == menu

            # Remove Class
            $scope.$broadcast('slideMenuGroup:closeStart', menu)

            $q.all([
              $animate.addClass($element, 'is-slide-menu-closed')
              $animate.removeClass($element, 'is-slide-menu-opened')
              $animate.addClass(html, 'is-slide-menu-closed')
              $animate.removeClass(html, 'is-slide-menu-opened')
            ]).then ->
              $scope.$broadcast('slideMenuGroup:closeEnd', menu)

          return this

        open: (menu) ->
          @toggle(menu, true)

        close: (menu) ->
          @toggle(menu, false)

        find: (menuId) ->
          _.find(@menus, { id: menuId })

        isActive: (menuId) ->
          @activeMenu?.id == menuId

      # Extend controller
      slideMenuGroup = new SlideMenuGroup

      @[key] = slideMenuGroup[key] for key of slideMenuGroup

  .directive 'slideMenuToggle', ($animate) ->
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

          @watch()

        toggle: ->
          @group.toggle(@targetId || @group.activeMenu)

          if @group.isActive(@targetId)
            $animate.addClass(element, 'is-slide-menu-opened')
            $animate.removeClass(element, 'is-slide-menu-closed')
          else
            $animate.addClass(element, 'is-slide-menu-closed')
            $animate.removeClass(element, 'is-slide-menu-opened')

          return this

        highlight: (highlight) ->
          if highlight
            $animate.addClass(element, 'is-slide-menu-opened')
            $animate.removeClass(element, 'is-slide-menu-closed')
          else
            $animate.addClass(element, 'is-slide-menu-closed')
            $animate.removeClass(element, 'is-slide-menu-opened')

        watch: ->
          scope.$on 'slideMenuGroup:openStart', =>
            @highlight(@group.isActive(@targetId))

          scope.$on 'slideMenuGroup:closeEnd', =>
            @highlight(@group.isActive(@targetId))

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
            $animate.addClass(element, 'is-slide-menu-opened')
            $animate.removeClass(element, 'is-slide-menu-closed')
          else
            $animate.addClass(element, 'is-slide-menu-closed')
            $animate.removeClass(element, 'is-slide-menu-opened')

          return this

        open: ->
          @toggle(true)

        close: ->
          @toggle(false)

      new SlideMenu

  .directive 'slideMenuContent', ($animate, $timeout, $compile, $window) ->
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
            @blocker = angular.element('<div>')
            
            @blocker.css {
              display: 'block'
              position: 'fixed'
              top: 0
              right: 0
              bottom: 0
              left: 0
              zIndex: 9999
              cursor: 'default'
              width: '100%'
            }

            @blocker.on 'touchstart click', (event) ->
              event.preventDefault()

              $timeout ->
                slideMenuGroup.toggle(slideMenuGroup.activeMenu, false)

            @blocker.on 'touchend', (event) ->
              event.preventDefault()

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
            # Set min-height
            element.css('min-height', $window.innerHeight)

            $animate.addClass(element, "is-slide-menu-opened is-#{ id }-opened")
            $animate.removeClass(element, "is-slide-menu-closed is-#{ id }-closed")

            # Block interaction
            @block()
          else
            # Set min-height
            element.css('min-height', '')

            $animate.addClass(element, "is-slide-menu-closed is-#{ id }-closed")
            $animate.removeClass(element, "is-slide-menu-opened is-#{ id }-opened")

            # Unblock interaction
            @unblock()

          return this

        open: (id) ->
          @toggle(id, true)

        close: (id) ->
          @toggle(id, false)

      new SlideMenuContent
