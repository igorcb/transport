class AddOwnerToDrivers < ActiveRecord::Migration
  def change
    add_reference :drivers, :owner, index: true
  end
end
