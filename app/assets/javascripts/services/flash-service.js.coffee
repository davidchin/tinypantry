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

      show: (type) ->
        @now = {}

        if type?
          return unless message = @messages[type]

          if message.requests == 0
            @now[type] = message
            @clear(type)
          else
            --message.requests
        else
          @show(type) for type, message of @messages when message?

      set: (text, options) ->
        message = _.extend({
          text: text
          type: 'alert'
          requests: 1
        }, options)

        @messages[message.type] = message

        @show(message.type)

      clear: (type) ->
        if type?
          @messages[type] = null
        else
          @clear(type) for type, message of @messages

        return @messages

  .factory 'flashFactory', ($rootScope, Flash) ->
    flashFactory =
      flashes: []

      get: (name) ->
        unless flash = _.find(@flashes, { name })
          flash = @add(new Flash(name))

        return flash

      add: (flash) ->
        @flashes.push(flash)

        return flash

      remove: (flash) ->
        index = _.indexOf(@flashes, flash)
        @flashes.splice(index, 1) if index >= 0

      show: ->
        flash.show() for flash in @flashes

      clear: ->
        flash.clear() for flash in @flashes

    $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) ->
      flashFactory.show() unless fromState.abstract

    return flashFactory

  .factory 'flash', (flashFactory) ->
    return flashFactory.get('app')
