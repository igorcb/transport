class AddMoppToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :number_mopp, :string
    add_column :drivers, :date_expiration_mopp, :date
  end
end
