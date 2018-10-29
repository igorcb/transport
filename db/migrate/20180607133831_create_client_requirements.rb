class CreateClientRequirements < ActiveRecord::Migration[5.0]
  def change
    create_table :client_requirements do |t|
      t.references :client, index: true
      t.integer :client_source_id, index: true
      t.integer :type_vehicle
      t.integer :type_body
      t.integer :type_floor

      t.timestamps
    end
  end
end
