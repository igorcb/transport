class AddTipoToVehicles < ActiveRecord::Migration[5.0]
  def change
    add_column :vehicles, :tipo, :integer
    add_column :vehicles, :tipo_carroceria, :integer
  end
end
