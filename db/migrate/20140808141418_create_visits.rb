class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.references :visitable, index: true, polymorphic: true
      t.integer :last_7_days_count, default: 0
      t.integer :last_30_days_count, default: 0
      t.integer :total_count, default: 0

      t.timestamps
    end
  end
end
