class CreateNfeKeys < ActiveRecord::Migration
  def change
    create_table :nfe_keys do |t|
      t.string :nfe, limit: 20, null: false
      t.string :chave, limit: 45, null: false
      t.integer :nfe_id
      t.string :nfe_type

      t.timestamps
    end
  end
end
