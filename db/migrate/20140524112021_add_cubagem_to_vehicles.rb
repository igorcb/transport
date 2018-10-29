class AddCubagemToVehicles < ActiveRecord::Migration[5.0]
  def change
    add_column :vehicles, :largura, :decimal, precision: 10, scale: 2
    add_column :vehicles, :comprimento, :decimal, precision: 10, scale: 2
    add_column :vehicles, :altura, :decimal, precision: 10, scale: 2
  end
end
