class AddSyncToDrivers < ActiveRecord::Migration[5.1]
  def change
    add_column :drivers, :sync, :boolean
  end
end
