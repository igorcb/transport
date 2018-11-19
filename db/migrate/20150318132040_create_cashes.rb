class CreateCashes < ActiveRecord::Migration[5.0]
  def change
    create_table :cashes do |t|
      t.date :data, presence: true, null: false, index: true
      t.decimal :valor, presence: true
      t.integer :tipo, presence: true
      t.references :payment_method, index: true
      t.references :cost_center, index: true
      t.references :sub_cost_center, index: true
      t.references :historic, index: true
      t.text :observacao

      t.timestamps
    end
  end
end
