Warden::Manager.before_logout do |resource, warden|
  if resource.respond_to?(:destroy_auth_token!)
    resource.destroy_auth_token!(warden.request.params[:auth_token])
  end
end
