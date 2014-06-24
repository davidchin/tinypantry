ngResourceDecorator = ($delegate) ->
  restfulActions = {
    index: {
      method: 'GET',
      isArray: true
    },

    show: {
      method: 'GET'
    },

    create: {
      method: 'POST'
    },

    update: {
      method: 'PUT'
    },

    patch: {
      method: 'PATCH'
    },

    destroy: {
      method: 'DELETE'
    }
  }

  (url, params, actions) ->
    actions = _.extend({}, actions, restfulActions)

    $delegate(url, params, actions)

# Register decorator
angular.module('resource')
  .config ($provide) ->
    $provide.decorator('$resource', ngResourceDecorator)
