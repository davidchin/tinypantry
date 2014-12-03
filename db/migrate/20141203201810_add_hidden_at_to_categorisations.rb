class AddHiddenAtToCategorisations < ActiveRecord::Migration
  def change
    add_column :categorisations, :hidden_at, :datetime
  end
end
