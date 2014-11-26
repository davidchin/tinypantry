angular.module('route')
  .factory 'query', ->
    fromParams: (params) ->
      parts = []

      for key, param of params
        continue if param == undefined || param == null

        values = if angular.isArray(param) then param else [param]

        for value in values
          value = angular.toJson(value) if _.isObject(value)
        
          parts.push(encodeURIComponent(key) + '=' + encodeURIComponent(value))

      parts.join('&')

    appendParams: (url, params) ->
      str = @fromParams(params)

      url + (if url.indexOf('?') == -1 then '?' else '&') + @fromParams(params)
