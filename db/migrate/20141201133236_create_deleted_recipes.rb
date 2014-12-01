class CreateDeletedRecipes < ActiveRecord::Migration
  def change
    create_table :deleted_recipes do |t|
      t.string :url, index: true
      t.references :feed, index: true

      t.timestamps
    end
  end
end
