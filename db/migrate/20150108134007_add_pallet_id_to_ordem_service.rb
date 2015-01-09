class AddPalletIdToOrdemService < ActiveRecord::Migration
  def change
    add_column :ordem_services, :pallet_id, :integer
  end
end
