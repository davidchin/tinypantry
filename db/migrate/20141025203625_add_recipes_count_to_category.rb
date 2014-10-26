class AddRecipesCountToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :recipes_count, :integer, default: 0
  end
end
