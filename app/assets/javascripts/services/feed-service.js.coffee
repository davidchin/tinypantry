angular.module('feed')
  .factory 'feedResource', ($resource) ->
    path = '/api/feeds/:id'
    params = { id: '@id' }

    return $resource(path, params)

  .factory 'Feed', (feedResource, Model) ->
    class Feed extends Model
      constructor: ->
        @configure(resource: feedResource)

        super

  .factory 'Feeds', (feedResource, Collection, Feed) ->
    class Feeds extends Collection
      constructor: ->
        @configure {
          resource: feedResource
          model: Feed
        }

        super
