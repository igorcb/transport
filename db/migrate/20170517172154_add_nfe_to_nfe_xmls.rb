class AddNfeToNfeXmls < ActiveRecord::Migration
  def change
    add_column :nfe_xmls, :nfe_id, :integer
    add_column :nfe_xmls, :nfe_type, :string
    add_column :nfe_xmls, :peso, :decimal, precision: 10, scale: 3
    add_column :nfe_xmls, :volume, :decimal, precision: 10, scale: 3
    add_column :nfe_xmls, :numero, :string
    add_column :nfe_xmls, :chave, :string, limit: 45
    add_column :nfe_xmls, :source_client_id, :integer
    add_column :nfe_xmls, :target_client_id, :integer
    add_column :nfe_xmls, :valor_nota, :decimal, precision: 20, scale: 4
    add_column :nfe_xmls, :equipamento, :integer
    add_column :nfe_xmls, :create_os, :integer
  end
end
