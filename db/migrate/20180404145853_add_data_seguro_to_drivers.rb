class AddDataSeguroToDrivers < ActiveRecord::Migration[5.0]
  def change
    add_column :drivers, :date_query_secure, :date
    add_column :drivers, :date_expiration_secure, :date
    add_column :drivers, :number_secure, :string
  end
end
