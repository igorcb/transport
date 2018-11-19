class CreateCteKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :cte_keys do |t|
      t.string :cte, limit: 20, null: false, index: true
      t.string :chave, limit: 45, index: true
      t.integer :cte_id
      t.string :cte_type

      t.timestamps
    end
  end
end
