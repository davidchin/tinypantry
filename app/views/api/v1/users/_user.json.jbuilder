json.extract! user, :id, :email

json.roles do
  json.array! user.roles, :id, :name
end
