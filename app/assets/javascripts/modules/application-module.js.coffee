angular.module 'application', [
  'bookmark'
  'category'
  'core'
  'config'
  'modal'
  'feed'
  'navigation'
  'recipe'
  'session'
  'user'
]

angular.module 'analytics', []

angular.module 'bookmark', [
  'core'
]

angular.module 'category', [
  'core'
]

angular.module 'core', [
  'analytics'
  'controller'
  'model'
  'flash'
  'resource'
  'route'
  'utility'
  'storage'
]

angular.module 'config', [
  'core'
]

angular.module 'controller', []

angular.module 'feed', [
  'core'
]

angular.module 'flash', []

angular.module 'modal', []

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
  'bookmark'
  'core'
  'session'
]

angular.module 'utility', [
  'ngAnimate'
  'ngSanitize'
]
