class AddAnttToVehicles < ActiveRecord::Migration
  def change
    add_column :vehicles, :antt, :string
  end
end
