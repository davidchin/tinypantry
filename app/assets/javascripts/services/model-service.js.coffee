angular.module('model')
  .factory 'ModelBase', ($q, localStorageService) ->
    class ModelBase
      constructor: (config) ->
        @config ||= {}
        @status ||= {}

        @configure(config)

      set: (data) ->
        @data = data if data?

      unset: ->
        @data = null

      store: (key, value) ->
        if value?
          localStorageService.set(key, value)
        else
          localStorageService.remove(key)

      retrieve: (key) ->
        localStorageService.get(key)

      configure: (config) ->
        _.extend(@config, config)

      read: (params) ->
        @request('get', params)
          .then (response) => @set(response)

      update: (params, data) ->
        @request('update', params, data)
          .then (response) => @set(response)

      create: (params, data) ->
        @request('create', params, data)
          .then (response) => @set(response)

      destroy: (params, data) ->
        @request('destroy', params, data)
          .then (response) => @unset() && response

      request: (action, params, data) ->
        output = @config.resource[action]?(params, data)

        output && output.$promise || $q.when(output)

      reject: (rejection) ->
        $q.reject(rejection)

    return ModelBase

  .factory 'Model', (ModelBase) ->
    class Model extends ModelBase
      constructor: (config) ->
        @data ||= {}

        super

      attr: (key, value) ->
        if _.isObject(key)
          return _.merge(@data, key)
        else if arguments.length > 1
          @data[key] = value

        @data[key]

      pick: (attrs...) ->
        _.pick(@data, attrs...)

      read: (params) ->
        @request('show', params)
          .then (response) => @set(response)

      update: (params, data) ->
        if @data.$update?
          @data.$update(data)
            .then (response) => @set(response)
        else
          super

      destroy: (params, data) ->
        if @data.$destroy?
          @data.$destroy(data)
            .then (response) => @unset() && response
        else
          super

    return Model

  .factory 'Collection', (ModelBase, Model) ->
    class Collection extends ModelBase
      constructor: (config) ->
        @data ||= []

        super

      set: (data) ->
        data = for item in data
          model = if @config.model?
            new @config.model(@config.modelConfig)
          else
            new Model

          model.set(item) && model

        super(data)

      find: (params) ->
        _.find(@data, params)

      where: (params) ->
        _.where(@data, params)

      pluck: (attr) ->
        _.pluck(@data, attr)

      add: (model) ->
        @data.push(model)

      remove: (model) ->
        index = _.indexOf(@data, model)

        @data.splice(index, 1) if index > -1

      read: (params) ->
        @request('index', params)
          .then (response) => @set(response)

    return Collection
