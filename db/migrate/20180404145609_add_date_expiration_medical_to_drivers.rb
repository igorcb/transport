class AddDateExpirationMedicalToDrivers < ActiveRecord::Migration[5.0]
  def change
    add_column :drivers, :date_expiration_medical, :date
  end
end
