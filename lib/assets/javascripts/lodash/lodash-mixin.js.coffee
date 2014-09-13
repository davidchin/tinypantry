_.mixin {
  camelizeObj: (obj) ->
    if _.isArray(obj)
      obj[i] = _.camelizeObj(item) for item, i in obj
    else if _.isObject(obj)
      _.transform obj, (result, value, key) ->
        result[_.string.camelize(key)] = if _.isPlainObject(value)
          _.camelizeObj(value)
        else
          value
    else
      return obj

  underscoredObj: (obj) ->
    if _.isArray(obj)
      obj[i] = _.underscoredObj(item) for item, i in obj
    else if _.isObject(obj)
      _.transform obj, (result, value, key) ->
        result[_.string.underscored(key)] = if _.isPlainObject(value)
          _.underscoredObj(value)
        else
          value
    else
      return obj
}
