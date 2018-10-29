class AddPalletIdToOrdemService < ActiveRecord::Migration[5.0]
  def change
    add_column :ordem_services, :pallet_id, :integer
  end
end
