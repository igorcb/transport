class CreateOwnerships < ActiveRecord::Migration[5.0]
  def change
    create_table :ownerships do |t|
      t.references :vehicle, index: true
      t.references :owner, index: true
      t.integer :ownership_id
      t.string :ownership_type

      t.timestamps
    end
  end
end
