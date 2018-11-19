class CreateOfferDrivers < ActiveRecord::Migration[5.0]
  def change
    create_table :offer_drivers do |t|
      t.references :offer_charge, index: true
      t.date :date_incoming
      t.time :time_incoming
      t.string :driver
      t.string :type_vehicle
      t.string :place_horse
      t.string :place_cart_first
      t.string :place_cart_second
      t.integer :status
      t.text    :observation
      t.references :user, index: true
      
      t.timestamps
    end
  end
end
