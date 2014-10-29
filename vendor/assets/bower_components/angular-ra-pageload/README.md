angular-ra-pageload.js
======================

`ra.pageload` module allows you to trigger an action after a page finishes loading, similar to listening for `DOMContentLoaded` event. Every time `$location` changes, the module waits for all `$http` requests to complete - including all API calls requested by your controllers and HTML partials requested by the `ng-include` directives in your views.

## Getting started

Include `ra.pageload` as a dependency of your application.

```javascript
angular.module('application', ['ra.pageload']);
```

## Usage

When the page content is ready, `$rootScope` broadcasts `pageload:ready` event to its child scopes. Therefore, you can listen for it in your controller and perform additional actions.

```javascript
angular.module('application')
  .controller('DemoCtrl', function($scope) {
    $scope.$on('pageload:ready', function() {
      // Do something
    });
  });
```
