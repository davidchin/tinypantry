angular.module('controller')
  .factory 'BaseController', ($q, $state, flash) ->
    class BaseController
      constructor: (scope) ->
        scope[key] = @[key] for key of @

      catchNotFoundError: (response) ->
        if response?.status == 404
          $state.go('errors.404', {}, { location: 'replace' })
        else
          return $q.reject(response)

      catchValidationError: (response, form) ->
        data = response?.data

        if data?.errors
          for key, errors of data.errors
            continue unless form[key]

            form[key].$setValidity('remote', false)
            form[key].$remoteError = errors

        else if data?.error
          flash.set(data.error, { requests: 0, type: 'alert' })

        else
          error = 'An error occurred and we\'ve been notified. We\'ll fix this error as soon as possible.'
          flash.set(error, { requests: 0, type: 'alert' })

        return $q.reject(response)
