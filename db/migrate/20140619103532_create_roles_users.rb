class CreateRolesUsers < ActiveRecord::Migration
  def change
    create_table :roles_users, id: false do |t|
      t.references :role, index: true
      t.references :user, index: true
    end
  end
end
