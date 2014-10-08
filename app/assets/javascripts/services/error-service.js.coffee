angular.module('error')
  .factory 'catchNotFoundError', ($q, $state) ->
    (error) ->
      if error?.status == 404
        $state.go('errors.404', {}, { location: 'replace' })
      else
        $q.reject(error)
