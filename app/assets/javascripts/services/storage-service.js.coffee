angular.module('storage')
  .config ($provide) ->
    # Decorate localStorageService until it fixes serialisation issue with cookie fallback
    $provide.decorator 'localStorageService', ($delegate) ->
      localStorageService = angular.copy($delegate)

      $delegate.set = (key, value) ->
        try value = angular.toJson(value) if _.isObject(value)

        localStorageService.set.call(@, key, value)

      $delegate.get = (key) ->
        value = localStorageService.get.call(@, key)

        try value = angular.fromJson(value)

        value

      return $delegate
