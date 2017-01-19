class CreateBoardingVehicles < ActiveRecord::Migration
  def change
    create_table :boarding_vehicles do |t|
      t.references :boarding, index: true
      t.references :vehicle, index: true

      t.timestamps
    end
  end
end
