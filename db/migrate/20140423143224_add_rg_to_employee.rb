class AddRgToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :rg, :string, limit: 20
    add_column :employees, :orgao_emissor, :string, limit: 20
    add_column :employees, :data_emissao_rg, :date
  end
end
