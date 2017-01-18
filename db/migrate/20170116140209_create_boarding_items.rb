class CreateBoardingItems < ActiveRecord::Migration
  def change
    create_table :boarding_items do |t|
      t.references :boarding, index: true
      t.references :ordem_service, index: true
      t.integer :delivery_number

      t.timestamps
    end
  end
end
