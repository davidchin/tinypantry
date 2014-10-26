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

          post.apply(null, arguments)

        return config

      return $delegate
