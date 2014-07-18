angular.module 'application', [
  'category'
  'core'
  'config'
  'navigation'
  'recipe'
  'session'
  'user'
]

angular.module 'category', [
  'core'
]

angular.module 'core', [
  'model'
  'resource'
  'route'
  'utility'
  'storage'
]

angular.module 'config', [
  'core'
]

angular.module 'model', [
  'storage'
]

angular.module 'navigation', [
  'core'
  'category'
]

angular.module 'recipe', [
  'core'
]

angular.module 'resource', [
  'ngResource'
]

angular.module 'route', [
  'ngRoute'
]

angular.module 'session', [
  'core'
  'user'
]

angular.module 'storage', [
  'LocalStorageModule'
  'ngCookies'
]

angular.module 'user', [
  'core'
  'session'
]

angular.module 'utility', [
  'ngSanitize'
]
