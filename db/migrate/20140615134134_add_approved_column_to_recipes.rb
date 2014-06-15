class AddApprovedColumnToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :approved, :boolean, default: false
  end
end
