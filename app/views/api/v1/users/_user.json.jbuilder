json.cache! ['v1', user] do
  json.extract! user, :id, :email, :display_name, :gravatar_id

  json.roles do
    json.array! user.roles, :id, :name
  end
end
