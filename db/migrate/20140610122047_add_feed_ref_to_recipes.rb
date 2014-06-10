class AddFeedRefToRecipes < ActiveRecord::Migration
  def change
    add_reference :recipes, :feed, index: true
  end
end
