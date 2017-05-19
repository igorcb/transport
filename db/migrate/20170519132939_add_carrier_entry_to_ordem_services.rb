class AddCarrierEntryToOrdemServices < ActiveRecord::Migration
  def change
    add_column :ordem_services, :carrier_entry_id, :integer, index: true
  end
end
