class AddRgToClient < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :rg, :string, limit: 20
    add_column :clients, :orgao_emissor, :string, limit: 20
    add_column :clients, :data_emissao_rg, :date
  end
end
