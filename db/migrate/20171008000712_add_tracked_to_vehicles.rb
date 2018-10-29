class AddTrackedToVehicles < ActiveRecord::Migration[5.0]
  def change
    add_column :vehicles, :tracked, :boolean, default: false
  end
end
