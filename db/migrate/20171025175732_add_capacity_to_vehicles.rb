class AddCapacityToVehicles < ActiveRecord::Migration
  def change
    add_column :vehicles, :capacity, :decimal, precision: 10, scale: 3
  end
end
