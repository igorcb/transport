class CreateOfferItems < ActiveRecord::Migration
  def change
    create_table :offer_items do |t|
      t.references :offer_charge, index: true
      t.string :city
      t.string :state
      t.string :client
      t.date :date_schedule
      t.time :time_schedule
      t.integer :qtde_pallets
      t.decimal :volume, :precision => 10, :scale => 3
      t.decimal :weight, :precision => 10, :scale => 3

      t.timestamps
    end
  end
end
