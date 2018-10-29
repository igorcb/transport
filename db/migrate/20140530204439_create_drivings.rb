class CreateDrivings < ActiveRecord::Migration[5.0]
  def self.up
    create_table :drivings do |t|
      t.references :driver, index: true
      t.references :vehicle, index: true
      t.integer :driving_id, index: true
      t.string  :driving_type
      t.timestamps
    end
  end

  def self.down
    drop_table :drivings
  end  
end
