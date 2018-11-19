class ChangeCapacityToVehicles < ActiveRecord::Migration[5.0]
  def change
    change_column :vehicles, :capacity, :decimal, precision: 10, scale: 2
  end
end
