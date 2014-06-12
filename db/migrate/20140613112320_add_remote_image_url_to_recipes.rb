class AddRemoteImageUrlToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :remote_image_url, :string
  end
end
