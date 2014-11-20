class CreateBillings < ActiveRecord::Migration
  def change
    create_table :billings do |t|
      t.date :data, null: false, index: true
      t.decimal :valor, precision: 10, scale: 2, null: false
      t.integer :status, null: false, default: 0
      t.text :obs

      t.timestamps
    end
  end
end
