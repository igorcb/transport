class CreateDriverRestrictions < ActiveRecord::Migration
  def change
    create_table :driver_restrictions do |t|
    	t.references :driver, index: true
      t.references :client, index: true
      t.integer :restriction
      t.text :observation

      t.timestamps
    end
  end
end
