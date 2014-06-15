class CreateCategorisations < ActiveRecord::Migration
  def change
    create_table :categorisations do |t|
      t.references :keywordable, index: true, polymorphic: true
      t.references :keyword, index: true

      t.timestamps
    end
  end
end
