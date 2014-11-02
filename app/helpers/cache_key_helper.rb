module CacheKeyHelper
  def prepend_roles!(keys)
    return keys unless current_user

    keys.unshift(current_user.role_names.map(&:downcase).join('-'))
        .reject!(&:empty?)

    keys
  end
end
