class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :tipo, limit: 5, null: false
      t.string :logradouro, limit: 100, null: false
      t.string :bairro, limit: 100, null: false
      t.string :estado, limit: 2, null: false
      t.string :cidade, limit: 100, null: false
      t.string :cep, limit: 10, null: false

      t.timestamps
    end
    add_index :addresses, :cep, unique: true
  end
end
