class AddRgToEmployee < ActiveRecord::Migration[5.0]
  def change
    add_column :employees, :rg, :string, limit: 20
    add_column :employees, :orgao_emissor, :string, limit: 20
    add_column :employees, :data_emissao_rg, :date
  end
end
