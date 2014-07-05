angular.module 'application', [
  'category'
  'core'
  'config'
  'navigation'
  'recipe'
  'resource'
  'session'
  'user'
]

angular.module 'category', [
  'core'
]

angular.module 'core', [
  'LocalStorageModule'
  'model'
  'ngCookies'
  'ngResource'
  'ngRoute'
]

angular.module 'config', [
  'core'
]

angular.module 'model', [
  'core'
]

angular.module 'navigation', [
  'core'
  'category'
]

angular.module 'recipe', [
  'core'
]

angular.module 'resource', [
  'core'
]

angular.module 'session', [
  'core'
]

angular.module 'user', [
  'core'
  'session'
]
