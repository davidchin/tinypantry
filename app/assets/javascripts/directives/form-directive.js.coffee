angular.module('form')
  .config ($provide) ->
    $provide.decorator 'ngModelDirective', ($delegate) ->
      directive = $delegate[0]
      compile = directive.compile

      directive.compile = ->
        config = compile.apply(null, arguments)
        post = config.post

        config.post = (scope, element, attrs, ctrls) ->
          modelCtrl = ctrls[0]

          # Clear remote error messages as soon as viewValue changes
          modelCtrl.$viewChangeListeners.push ->
            return unless modelCtrl.$remoteError

            modelCtrl.$setValidity('remote', true)
            modelCtrl.$remoteError = null

          # Apply super method
          post.apply(null, arguments)

        return config

      return $delegate

  .directive 'validate', ->
    restrict: 'A',
    require: 'ngModel'
    link: (scope, element, attrs, modelCtrl) ->
      return unless attrs.validate

      validators = scope.$eval(attrs.validate)

      if _.isFunction(validators)
        fnExp = attrs.validate.split('.')
        fnName = fnExp.pop()
        fnContext = scope.$eval(fnExp.join('.'))
        validators[fnName] = validators.bind(fnContext)

      if _.isObject(validators)
        _.merge(modelCtrl.$validators, validators)
