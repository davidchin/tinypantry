angular.module('navigation')
  .run ($rootScope, breadcrumbs) ->
    $rootScope.$on '$stateChangeSuccess', ->
      breadcrumbs.reset()

  .factory 'breadcrumbs', ($state) ->
    class Breadcrumbs
      constructor: ->
        @items = []

      add: (name, state, stateParams) ->
        @add('Home', 'home') if @items.length == 0 && state != 'home'

        path = $state.href(state, stateParams)
        @items.push({ name, path })

        return @

      remove: (name) ->
        index = _.findIndex(@items, { name })
        @items.splice(index, 1) if index > -1

        return @

      reset: ->
        @items.length = 0

        return @

    new Breadcrumbs
