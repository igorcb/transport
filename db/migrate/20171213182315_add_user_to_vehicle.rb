class AddUserToVehicle < ActiveRecord::Migration[5.0]
  def change
    add_reference :vehicles, :user_created, index: true
    add_reference :vehicles, :user_updated, index: true
  end
end
