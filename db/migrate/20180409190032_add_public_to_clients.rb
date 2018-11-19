class AddPublicToClients < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :orgao_publico, :boolean
    add_column :clients, :icms_contribuinte, :boolean
    add_column :clients, :tipo_cliente, :integer
  end
end
