class AddAnttToVehicles < ActiveRecord::Migration[5.0]
  def change
    add_column :vehicles, :antt, :string
  end
end
