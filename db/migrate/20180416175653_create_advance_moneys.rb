class CreateAdvanceMoneys < ActiveRecord::Migration
  def change
    create_table :advance_moneys do |t|
      t.date :date_advance
      t.string :number
      t.decimal :price, precision: 20, scale: 4, default: 0

      t.timestamps
    end
  end
end
