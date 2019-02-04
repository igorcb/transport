class AddDoorsToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :door, :integer
  end
end
