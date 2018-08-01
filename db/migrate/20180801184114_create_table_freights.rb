class CreateTableFreights < ActiveRecord::Migration
  def change
    create_table :table_freights do |t|
      t.integer :type_charge
      t.integer :km_from
      t.integer :km_to
      t.decimal :price, precision: 10, scale: 2

      t.timestamps
    end
  end
end
