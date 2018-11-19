class AddCapacityToVehicles < ActiveRecord::Migration[5.0]
  def change
    add_column :vehicles, :capacity, :decimal, precision: 10, scale: 3
  end
end
