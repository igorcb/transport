class RemoveHistoricIdFromCash < ActiveRecord::Migration[5.0]
  def change
    remove_column :cashes, :historic_id, :integer
  end
end
