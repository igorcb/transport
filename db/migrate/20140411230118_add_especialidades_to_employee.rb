class AddEspecialidadesToEmployee < ActiveRecord::Migration
  def change
    add_column :employees, :carrega, :boolean, default: false
    add_column :employees, :embala, :boolean, default: false
    add_column :employees, :desmonta, :boolean, default: false
    add_column :employees, :icamento, :boolean, default: false
    add_column :employees, :arruma, :boolean, default: false
    add_column :employees, :iventarista, :boolean, default: false
    add_column :employees, :confere_carga, :boolean, default: false
  end
end
