class AddUserToVehicles < ActiveRecord::Migration[5.0]
  def change
    add_reference :vehicles, :user, index: true
  end
end
