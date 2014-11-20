angular.module('config')
  .run ($rootScope, head) ->
    $rootScope.$on '$stateChangeSuccess', ->
      head.reset()

  .factory 'head', ->
    set: (title, description) ->
      @title = title

      if description.length > 150
        @description = description.substr(0, 150) + '...'
      else
        @description = description

    reset: ->
      @title = ""
      @description = ""
