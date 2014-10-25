angular.module('modal')
  .directive 'modalButton', ($timeout, Modal) ->
    restrict: 'EA'
    scope: true
    link: (scope, element, attrs) ->
      name = attrs.name || 'modal'
      location = attrs.modalButton || attrs.location
      name = _.string.camelize(attrs.name || "#{ location } modal")

      # Initialise modal
      modal = new Modal({ scope })

      # Register event
      element.on 'click', (event) ->
        event.preventDefault()

        $timeout -> modal.open(location)

      # Assign to scope
      scope[name] = modal

  .directive 'modalCloseButton', ($timeout, modalStack) ->
    restrict: 'EA'
    link: (scope, element) ->
      element.on 'click', ->
        $timeout -> modalStack.close()
