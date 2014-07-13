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
  'LocalStorageModule'
  'model'
  'ngCookies'
  'ngResource'
  'ngRoute'
  'ngSanitize'
  'resource'
  'utility'
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
  'user'
]

angular.module 'user', [
  'core'
  'session'
]

angular.module 'utility', [
  'core'
]
