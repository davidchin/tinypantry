angular.module('seo')
  .run ($rootScope, head) ->
    $rootScope.$on '$stateChangeSuccess', ->
      head.reset()

  .factory 'head', ->
    set: (title, description) ->
      @title = title

      if description?.length > 150
        @description = description.substr(0, 150) + '...'
      else if description?
        @description = description

    reset: ->
      @title = ""
      @description = ""
