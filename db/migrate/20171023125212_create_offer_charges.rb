class CreateOfferCharges < ActiveRecord::Migration[5.0]
  def change
    create_table :offer_charges do |t|
      t.string :shipper
      t.date :date_shipment
      t.time :time_shipment
      t.string :shipping
      t.string :local_loading
      t.string :type_vehicle
      t.string :vehicle_detail
      t.integer :vehicle_situation
      t.decimal :freight_min, :precision => 10, :scale => 3
      t.decimal :freight_max, :precision => 10, :scale => 3
      t.integer :status
      t.references :user, index: true

      t.timestamps
    end
  end
end