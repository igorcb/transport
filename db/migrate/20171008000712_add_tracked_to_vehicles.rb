class AddTrackedToVehicles < ActiveRecord::Migration
  def change
    add_column :vehicles, :tracked, :boolean, default: false
  end
end
