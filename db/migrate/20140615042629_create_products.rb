class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :descricao, null: false
      t.decimal :cubagem, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
