class AddBookmarksCountToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :bookmarks_count, :integer, default: 0
  end
end
