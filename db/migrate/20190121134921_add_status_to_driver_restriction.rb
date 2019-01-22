class AddStatusToDriverRestriction < ActiveRecord::Migration[5.1]
  def change
    add_column :driver_restrictions, :status, :integer
  end

  def data
    DriverRestriction.update_all(status: 0)
  end
end
