class ChangeCapacityToVehicles < ActiveRecord::Migration
  def change
    change_column :vehicles, :capacity, :decimal, precision: 10, scale: 2
  end
end
