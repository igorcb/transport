class CreateWarehouses < ActiveRecord::Migration[5.1]
  def change
    create_table :warehouses do |t|
      t.string :name
      t.string :address
      t.string :number
      t.string :district
      t.string :city
      t.string :state
      t.string :zip_code

      t.timestamps
    end
  end
end
