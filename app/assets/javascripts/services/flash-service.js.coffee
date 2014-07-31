angular.module('flash')
  .factory 'Flash', ->
    class Flash
      constructor: (@name) ->
        @messages = {
          alert: null
          info: null
          success: null
          error: null
        }

      set: (message, type) ->
        type ||= 'alert'

        @messages[type] = {
          text: message
          type: type
          visible: false
        }

      clear: (type) ->
        if type?
          @messages[type] = null
        else
          @clear(type) for type, message of @messages

        return @messages

    return Flash

  .factory 'flash', (flashFactory) ->
    return flashFactory.get('app')

  .factory 'flashFactory', ($rootScope) ->
    flashFactory =
      flashes: []

      get: (name) ->
        flash = _.find(@flashes, { name }) || new Flash(name)

      reset: ->
        flash.clear() for flash in @flashes

    $rootScope.$on '$routeChangeSuccess', => flashFactory.reset()

    return flashFactory
