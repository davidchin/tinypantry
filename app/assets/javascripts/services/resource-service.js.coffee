angular.module('resource')
  .config ($provide) ->
    $provide.decorator '$resource', ($delegate) ->
      restfulActions =
        index:
          method: 'GET'
          isArray: true

        show:
          method: 'GET'

        create:
          method: 'POST'

        update:
          method: 'PUT'

        patch:
          method: 'PATCH'

        destroy:
          method: 'DELETE'

      return (url, params, actions) ->
        actions = _.extend({}, actions, restfulActions)

        $delegate(url, params, actions)
