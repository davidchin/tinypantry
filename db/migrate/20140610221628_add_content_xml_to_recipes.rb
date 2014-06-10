class AddContentXmlToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :content_xml, :text
  end
end
