angular.module('tinyPantry', [
  'category',
  'navigation',
  'recipe',
  'resource',
  'route',
  'session'
])

angular.module('category', [
  'ngResource'
])

angular.module('navigation', [
  'category'
])

angular.module('recipe', [
  'ngResource'
])

angular.module('resource', [
  'ngResource'
])

angular.module('route', [
  'ngRoute'
])

angular.module('session', [
  'ngRoute'
])
