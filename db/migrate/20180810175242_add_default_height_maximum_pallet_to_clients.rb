class AddDefaultHeightMaximumPalletToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :default_height_maximum_pallet, :decimal, precision: 10, scale: 2
    add_column :clients, :type_height_maximum_pallet, :integer
  end
end