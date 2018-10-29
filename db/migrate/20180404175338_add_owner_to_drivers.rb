class AddOwnerToDrivers < ActiveRecord::Migration[5.0]
  def change
    add_reference :drivers, :owner, index: true
  end
end
