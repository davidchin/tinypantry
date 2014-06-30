Warden::Manager.before_logout do |resource, warden|
  if resource.respond_to?(:destroy_auth_token!)
    resource.destroy_auth_token!(warden.request.params[:auth_token])
  end
end

Warden::Manager.after_set_user do |resource, warden|
  if resource.respond_to?(:generate_auth_token!)
    resource.generate_auth_token! unless warden.request.params.key?(:auth_token)
  end
end
