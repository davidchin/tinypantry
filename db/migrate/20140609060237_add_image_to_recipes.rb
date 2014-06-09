class AddImageToRecipes < ActiveRecord::Migration
  def up
    add_attachment :recipes, :image
  end

  def down
    remove_attachment :recipes, :image
  end
end
