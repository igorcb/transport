class AddBoxByPalletToProducts < ActiveRecord::Migration
  def change
    add_column :products, :box_by_pallet, :integer
    add_column :products, :layer_pallet, :integer
    add_column :products, :und_in_box, :integer
    add_column :products, :family_id, :integer
    add_column :products, :ean_box, :string
  end
end
