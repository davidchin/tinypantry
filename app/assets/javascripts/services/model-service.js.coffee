angular.module('model')
  .factory 'Model', ($q, localStorageService) ->
    class Model
      constructor: (config) ->
        @status = {}
        @configure(config)

      set: (data) ->
        @data ?= data

      unset: ->
        @data = null

      store: (key, value) ->
        if value?
          localStorageService.set(key, value)
        else
          localStorageService.remove(key)

        return value

      retrieve: (key) ->
        localStorageService.get(key)

      show: (params) ->
        @request('show', params, data)
          .then (response) => @set(response)

      index: (params) ->
        @request('index', params, data)
          .then (response) => @set(response)

      update: (params, data) ->
        @request('update', params, data)
          .then (response) => @set(response)

      create: (params, data) ->
        @request('create', params, data)
          .then (response) => @set(response)

      destroy: (params, data) ->
        @request('destroy', params, data)
          .then (response) => @unset()

      configure: (config) ->
        @config ?= {}

        _.extend(@config, config)

      request: (action, params, data) ->
        output = @config.resource[action]?(params, data)

        output && output.$promise || $q.when(output)

    return Model
