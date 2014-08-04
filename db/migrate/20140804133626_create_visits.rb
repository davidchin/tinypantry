class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.references :visitable, index: true, polymorphic: true
      t.references :user, index: true
      t.string :request_uuid
      t.string :ip_address
      t.string :referrer

      t.timestamps
    end

    add_column :recipes, :visits_count, :integer, default: 0
  end
end
