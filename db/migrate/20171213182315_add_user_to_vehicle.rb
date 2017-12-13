class AddUserToVehicle < ActiveRecord::Migration
  def change
    add_reference :vehicles, :user_created, index: true
    add_reference :vehicles, :user_updated, index: true
  end
end
