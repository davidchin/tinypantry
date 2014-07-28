json.cache! ['v1', 'index', @users] do
  json.partial! 'api/v1/users/user', collection: @users, as: :user
end
