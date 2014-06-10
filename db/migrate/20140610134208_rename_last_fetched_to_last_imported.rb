class RenameLastFetchedToLastImported < ActiveRecord::Migration
  def change
    rename_column :feeds, :last_fetched, :last_imported
  end
end
