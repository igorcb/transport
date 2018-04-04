class AddDateExpirationMedicalToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :date_expiration_medical, :date
  end
end
