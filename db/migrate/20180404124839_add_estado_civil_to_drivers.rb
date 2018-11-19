class AddEstadoCivilToDrivers < ActiveRecord::Migration[5.0]
  def change
    add_column :drivers, :estado_civil, :integer
    add_column :drivers, :cor_da_pele, :integer
    add_column :drivers, :tipo_contrato, :integer
  end
end
