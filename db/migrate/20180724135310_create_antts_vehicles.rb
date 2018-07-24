class CreateAnttsVehicles < ActiveRecord::Migration
  def change
    create_table :antts_vehicles do |t|
      t.references :antt, index: true
      t.references :vehicle, index: true

      t.timestamps
    end
  end
end
