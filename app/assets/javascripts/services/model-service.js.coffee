angular.module('model')
  .factory 'BaseModel', ($q, localStorageService) ->
    class BaseModel
      constructor: (config) ->
        @config ||= {}
        @status ||= {}
        @requests ||= {}
        @dataAttrs ||= []

        @configure(config)

      set: (data) ->
        for attr, value of data
          continue if _.isFunction(@[attr]) || _.isFunction(value) || /^\$/.test(attr)

          # Keep track of which attributes are data attributes
          @dataAttrs.push(attr) unless _.contains(@dataAttrs, attr)

          # Set attribute
          @[attr] = value

      unset: ->
        delete @[attr] for attr in @dataAttrs

      data: ->
        _.pick(@, @dataAttrs)

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
          @status["#{ action }#{ _.string.capitalize(flag) }"] = value

        return @status

    return BaseModel

  .factory 'Model', (BaseModel) ->
    class Model extends BaseModel
      pick: (attrs...) ->
        _.pick(@data(), attrs...)

      read: (params) ->
        @request('show', params)
          .then (response) => @set(response)

      create: (params, data) ->
        data ||= @data()

        super(params, data)

      update: (params, data) ->
        data ||= @data()

        super(params, data)
          .then (response) => @set(response)

    return Model

  .factory 'Collection', (BaseModel, Model) ->
    class Collection extends BaseModel
      constructor: (config) ->
        @items ||= []

        super

      data: ->
        @items.slice()

      set: (data) ->
        data = for item in data
          model = if @config.model?
            new @config.model(@config.modelConfig)
          else
            new Model

          model.set(item) && model

        @items.length = 0
        @items.push.apply(@items, data)

      find: (params) ->
        _.find(@items, { data: params })

      where: (params) ->
        _.where(@items, { data: params })

      any: (params) ->
        _.any(@items, { data: params })

      pluck: (attr) ->
        _.pluck(@items, attr)

      invoke: (method, params...) ->
        _.invoke(@items, method, params...)

      add: (model) ->
        @items.push(model)

      remove: (model) ->
        index = _.indexOf(@items, model)

        @items.splice(index, 1) if index > -1

      read: (params) ->
        @request('index', params)
          .then (response) => @set(response)

    return Collection
