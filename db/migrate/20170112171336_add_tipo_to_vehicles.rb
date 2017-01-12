class AddTipoToVehicles < ActiveRecord::Migration
  def change
    add_column :vehicles, :tipo, :integer
    add_column :vehicles, :tipo_carroceria, :integer
  end
end
