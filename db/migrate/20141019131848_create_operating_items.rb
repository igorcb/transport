class CreateOperatingItems < ActiveRecord::Migration[5.0]
  def change
    create_table :operating_items do |t|
      t.references :operating, index: true
      t.references :product, index: true
      t.integer :qtde
      t.string :unidade, limit: 3
      t.decimal :valor, precision: 10, scale: 2

      t.timestamps
    end
  end
end
