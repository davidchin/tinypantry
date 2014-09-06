_.mixin {
  camelizeObj: (obj) ->
    return obj unless _.isObject(obj)

    _.transform obj, (result, value, key) ->
      result[_.string.camelize(key)] = value

  underscoredObj: (obj) ->
    return obj unless _.isObject(obj)

    _.transform obj, (result, value, key) ->
      result[_.string.underscored(key)] = value
}
