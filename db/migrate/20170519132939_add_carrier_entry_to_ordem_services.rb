class AddCarrierEntryToOrdemServices < ActiveRecord::Migration[5.0]
  def change
    add_column :ordem_services, :carrier_entry_id, :integer, index: true
  end
end
