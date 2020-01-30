class CreateDevolutions < ActiveRecord::Migration[5.1]
  def change
    create_table :devolutions do |t|
      t.references :carrier
      t.references :driver
      t.references :billing_client, :foreign_key => {to_table: :clients }
      t.string :place
      t.string :place_horse
      t.string :place_cart_1
      t.date :date_entry
      t.time :time_entry
      t.date :date_receipt
      t.date :date_closing
      t.date :date_scheduled
      t.time :time_scheduled
      t.text :motive_scheduled
      t.boolean :palletized
      t.integer :quantity_pallets
      t.decimal :weight, precision: 10, scale: 3, null: true
      t.decimal :volume, precision: 10, scale: 3, null: true
      t.decimal :value_ton, precision: 10, scale: 2, null: true
      t.decimal :value_kg, precision: 10, scale: 2, null: true
      t.decimal :value_total, precision: 10, scale: 2, null: true
      t.boolean :charge_discharge
      t.string  :shipment
      t.integer :team
      t.integer :dock
      t.integer :hangar
      t.string :container
      t.string :place_confirmed
      t.string :charge_type_delivery
      t.references :started_user, foreign_key:  {to_table: :users }
      t.datetime :start_time_discharge
      t.datetime :finish_time_discharge
      t.references :breakdown_user, foreign_key:  {to_table: :users }
      t.datetime :date_start_avaria
      t.datetime :date_finish_avaria
      t.time :time_start_avaria
      t.time :time_finish_avaria
      t.integer :status
      t.references :user, foreign_key:  {to_table: :users }
      t.references :received_user, foreign_key:  {to_table: :users }
      t.text :observation

      t.timestamps
    end
  end
end
