angular.module('route')
  .directive 'uiSrefAlias', ($state, $stateParams, $interpolate) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      # Interpolate attributes
      aliasState = $state.get(attrs.uiSrefAlias)
      activeClass = $interpolate(attrs.uiSrefActiveEq || attrs.uiSrefActive || '', false)(scope)
      params = null

      # Parse uiSref attr
      parseStateRef = (ref, current) ->
        preparsed = ref.match(/^\s*({[^}]*})\s*$/)
        ref = current + '(' + preparsed[1] + ')' if preparsed

        parsed = ref.replace(/\n/g, " ").match(/^([^(]+?)\s*(\((.*)\))?$/)

        return state: parsed[1], paramExpr: parsed[3] || null

      # Compare params
      matchesParams = (paramsA, paramsB) ->
        keys = _.keys(paramsA)

        return false for key in keys when `paramsA[key] != paramsB[key]`
        return true

      # Update active state
      update = ->
        # Check if matching alias state
        if typeof attrs.uiSrefActiveEq != 'undefined'
          matched = $state.current == aliasState
        else
          matched = $state.includes(aliasState.name)

        # Check if params also matched
        if matched && params
          matched = matchesParams(params, $stateParams)

        # Add activeClass if matched
        element.addClass(activeClass) if matched

      # Parse state ref
      ref = parseStateRef(attrs.uiSref, $state.current.name)

      # Watch for scope chanes regarding state params
      scope.$watch ref.paramExpr, ->
        params = scope.$eval(ref.paramExpr)
        update()

      # Watch for state change
      scope.$on '$stateChangeSuccess', update
