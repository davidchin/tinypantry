angular.module('model')
  .factory 'ModelBase', ($q, localStorageService) ->
    # TODO
    # Remove @data, merge data as direct attributes of model
    # Ability to specify not to send certain attributes

    class ModelBase
      constructor: (config) ->
        @data || {}
        @config ||= {}
        @status ||= {}
        @requests ||= {}
        @requestStatus ||= {}

        @configure(config)

      set: (data) ->
        @data = data if data?

      unset: ->
        @data = null

      merge: (data) ->
        _.merge(@data, data) if data?

      store: (key, value) ->
        if value?
          localStorageService.set(key, value)
        else
          localStorageService.remove(key)

      retrieve: (key) ->
        localStorageService.get(key)

      configure: (config = {}) ->
        @config ||= {}

        _.extend(@config, _.omit(config, 'dependency'))
        _.defaults(this, config.dependency)

      params: ->
        {}

      ready: (params) ->
        if !@requests.read
          @read(params)
        else
          $q.when(@requests.read)

      read: (params) ->
        @request('get', params)
          .then (response) => @set(response)

      update: (params, data) ->
        @request('update', params, data)
          .then (response) => @set(response)

      patch: (params, data) ->
        @request('patch', params, data)
          .then (response) => @set(response)

      create: (params, data) ->
        @request('create', params, data)
          .then (response) => @set(response)

      destroy: (params) ->
        @request('destroy', params)
          .then (response) => @unset() && response

      request: (action, params, data) ->
        # Params
        params = _.extend({}, @params(), params)

        # Data - set additional keys for nested attributes
        data = _.reduce data, (output, value, attr) ->
          if _.isArray(value) || _.isObject(value)
            output["#{ attr }_attributes"] = value

          return output
        , _.pick(data, (value, attr) -> /^(?!\$)/.test(attr))

        # Call ngResource
        output = @config.resource[action]?(params, data)

        if output
          promise = output.$promise || $q.when(output)

          # Flag status
          @flag(action, 'pending')

          @requests[action] = promise.then (response) =>
            @flag(action, 'success') && response
          , (response) =>
            @flag(action, 'error') && response

        else
          $q.reject()

      flag: (action, status) ->
        flags =
          pending:
            pending: true
            complete: false
            success: false
            error: false
          success:
            pending: false
            complete: true
            success: true
            error: false
          error:
            pending: false
            complete: true
            success: false
            error: true

        for flag, value of flags[status]
          @requestStatus["#{ action }#{ _.string.capitalize(flag) }"] = value

        return @requestStatus

    return ModelBase

  .factory 'Model', (ModelBase) ->
    class Model extends ModelBase
      constructor: (config) ->
        @data ||= {}

        super

      attr: (key, value) ->
        if _.isObject(key)
          return @merge(key)
        else if arguments.length > 1
          @data[key] = value

        @data[key]

      pick: (attrs...) ->
        _.pick(@data, attrs...)

      read: (params) ->
        @request('show', params)
          .then (response) => @set(response)

      create: (params, data) ->
        data ||= @data

        super(params, data)

      update: (params, data) ->
        data ||= @data

        super(params, data)
          .then (response) => @set(response)

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
        _.find(@data, { data: params })

      where: (params) ->
        _.where(@data, { data: params })

      any: (params) ->
        _.any(@data, { data: params })

      pluck: (attr) ->
        _.pluck(@data, attr)

      invoke: (method, params...) ->
        _.invoke(@data, method, params...)

      add: (model) ->
        @data.push(model)

      remove: (model) ->
        index = _.indexOf(@data, model)

        @data.splice(index, 1) if index > -1

      read: (params) ->
        @request('index', params)
          .then (response) => @set(response)

    return Collection
