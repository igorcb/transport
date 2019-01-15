class CreateVehicleRestrictions < ActiveRecord::Migration[5.1]
  def change
    create_table :vehicle_restrictions do |t|
      t.references :vehicle, foreign_key: true
      t.integer :motive_id
      t.text :motive_observation
      t.integer :status

      t.timestamps
    end
  end
end
