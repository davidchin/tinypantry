class CreateAuthTokens < ActiveRecord::Migration
  def change
    create_table :auth_tokens do |t|
      t.references :user, index: true
      t.string :encrypted_secret

      t.timestamps
    end

    remove_column :users, :encrypted_auth_token, :string
  end
end
