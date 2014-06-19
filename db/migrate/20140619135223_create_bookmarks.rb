class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.references :recipe, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
