class AddFieldsNfeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :cod_prod, :string
    add_column :products, :ncm, :string
    add_column :products, :cest, :string
    add_column :products, :cfop, :string
    add_column :products, :ean, :string
    add_column :products, :unid_medida, :string
    add_column :products, :ean_trib, :string
    add_column :products, :unid_medida_trib, :string
    add_column :products, :valor_unitario, :decimal, precision: 20, scale: 10
  end
end
