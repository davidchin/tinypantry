class AddPublishedAtToRecipe < ActiveRecord::Migration
  def change
    add_column :recipes, :published_at, :datetime
    add_column :recipes, :imported_at, :datetime
  end
end
