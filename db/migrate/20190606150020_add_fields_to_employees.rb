class AddFieldsToEmployees < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :data_nascimento, :date
    add_column :employees, :nacionalidade, :string
    add_column :employees, :naturalidade, :string
    add_column :employees, :grau_de_instrucao, :integer
    add_column :employees, :nome_da_mae, :string
    add_column :employees, :nome_do_pai, :string
    add_column :employees, :ctps, :integer
    add_column :employees, :ctps_serie, :integer
    add_column :employees, :ctps_uf, :integer
    add_column :employees, :ctps_expedicao, :date
    add_column :employees, :pis, :integer
    add_column :employees, :cnh, :string
    add_column :employees, :registro_cnh, :string
    add_column :employees, :validade_cnh, :date
    add_column :employees, :categoria, :integer
    add_column :employees, :titulo_eleitor, :integer
    add_column :employees, :zona_eleitor, :integer
    add_column :employees, :secao_eleitor, :integer
  end
end
