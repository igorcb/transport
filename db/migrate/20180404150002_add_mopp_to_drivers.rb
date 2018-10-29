class AddMoppToDrivers < ActiveRecord::Migration[5.0]
  def change
    add_column :drivers, :number_mopp, :string
    add_column :drivers, :date_expiration_mopp, :date
  end
end
