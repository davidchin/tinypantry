angular.module('model')
  .factory 'BaseModel', ($q, localStorageService) ->
    class BaseModel
      constructor: (config) ->
        @config ||= {}
        @status ||= {}
        @requests ||= {}
        @headers ||= {}
        @dataAttrs ||= []

        @configure(config)

      set: (data) ->
        @attr(data)
        @status.set = true

        return data

      unset: ->
        @status.set = false

        delete @[attr] for attr in @dataAttrs

      attr: (attr, value) ->
        data = {}

        if _.isString(attr)
          data[attr] = value
        else
          data = attr
        
        for attr, value of data
          continue if _.isFunction(@[attr]) || _.isFunction(value) || /^\$/.test(attr)

          # Keep track of which attributes are data attributes
          @dataAttrs.push(attr) unless _.contains(@dataAttrs, attr)

          # Set attribute
          @[attr] = value

        return @

      data: ->
        if @dataAttrs?.length
          _.pick(@, @dataAttrs)
        else
          ignoreAttrs = ['config', 'status', 'requests', 'headers', 'dataAttrs']
          ignoreAttrs = ignoreAttrs.concat(@config.dependency)
  
          _.transform @, (output, value, attr) =>
            return if typeof value == 'function' ||
                      attr in ignoreAttrs ||
                      _.hasValue(value, @)

            if _.isFunction(value?.data)
              output[attr] = value.data()
            else
              output[attr] = value

      store: (key, value) ->
        if value?
          localStorageService.set(key, value)
        else
          localStorageService.remove(key)

      retrieve: (key) ->
        localStorageService.get(key)

      configure: (config = {}) ->
        @config ||= {}

        # Set dependency as an array of keys
        @config.dependency = _.union(_.keys(config.dependency), @config.dependency)

        # Extend config
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
        @status.set = false

        @request('get', params)
          .then (response) => @set(response)

      create: (params, data) ->
        @request('create', params, data)
          .then (response) => @set(response)

      update: (params, data) ->
        @request('update', params, data)

      patch: (params, data) ->
        @request('patch', params, data)

      destroy: (params) ->
        @request('destroy', params)

      request: (action, params, data) ->
        # Params
        params = _.extend({}, @params(), params)

        # Data - set additional keys for nested attributes
        data = _.transform data, (output, value, attr) ->
          if _.isArray(value) || _.isObject(value)
            output["#{ attr }_attributes"] = value
          else if /^(?!\$)/.test(attr)
            output[attr] = value

        # Call ngResource
        onSuccess = (response, headers) =>
          @headers[action] = headers
          @pagination = pagination if (pagination = headers?('pagination'))

        output = @config.resource[action]?(params, data, onSuccess)

        if output
          promise = output.$promise || $q.when(output)

          # Flag status
          @flag(action, 'pending')

          @requests[action] = promise.then (response) =>
            @flag(action, 'success')

            return response
          , (response) =>
            @flag(action, 'error')

            return $q.reject(response)

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

      destroy: (params) ->
        params ||= {}
        _.defaults(params, @pick('id'))

        super(params)
          .then (response) =>
            @unset()

            return response

  .factory 'Collection', ($q, BaseModel, Model) ->
    class Collection extends BaseModel
      constructor: (config) ->
        @items ||= []

        super

      data: ->
        @items.slice()

      set: (data) ->
        @items.length = 0
        @status.empty = true
        @status.set = true

        @add(@transform(item)) for item in data

      transform: (item, config) ->
        config ||= @config

        model = if config.model?
          new config.model(config.modelConfig)
        else
          new Model

        model.set(item)

        return model

      find: (params) ->
        _.find(@items, params)

      where: (params) ->
        _.where(@items, params)

      any: (params) ->
        _.any(@items, params)

      pluck: (attr) ->
        _.pluck(@items, attr)

      invoke: (method, params...) ->
        _.invoke(@items, method, params...)

      add: (models...) ->
        @items.push(model) for model in models when !_.contains(@items, model)
        @status.empty = @items.length == 0

        return @items

      remove: (models...) ->
        @items.splice(index, 1) for model in models when (index = @indexOf(model)) >= 0
        @status.empty = @items.length == 0

        return @items

      indexOf: (model) ->
        _.indexOf(@items, model)

      read: (params) ->
        @status.set = false

        @request('index', params)
          .then (response) => @set(response)

      readAll: (params) ->
        @status.set = false

        promise = null
        params.page = params.page || 1

        for page in [1..params.page]
          params = angular.copy(params)
          params.page = page

          if promise
            promise = promise.then => @append(params)
          else
            promise = @append(params)

          if page == params.page
            promise.then => @status.set = true

        promise

      append: (params) ->
        @request('index', params)
          .then (response) =>
            @add(@transform(item)) for item in response

      update: (params, data) ->
        if model = @find(_.pick(params, 'id'))
          model.update(params, data)
        else
          super(params, data)

      destroy: (params) ->
        if model = @find(_.pick(params, 'id'))
          model.destroy(params)
            .then => @remove(model)
        else
          super(params)
