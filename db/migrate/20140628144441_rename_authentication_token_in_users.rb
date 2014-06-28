class RenameAuthenticationTokenInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :authentication_token, :encrypted_auth_token
  end
end
