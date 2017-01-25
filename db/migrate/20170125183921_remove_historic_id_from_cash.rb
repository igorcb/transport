class RemoveHistoricIdFromCash < ActiveRecord::Migration
  def change
    remove_column :cashes, :historic_id, :integer
  end
end
