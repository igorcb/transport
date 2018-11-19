class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.string :cpf_cnpj, limit: 18, null: false
      t.string :nome, limit: 100, null: false
      t.string :fantasia, limit: 100, null: false
      t.integer :address_id, null: false
      t.foreign_key :addresses
      t.string :numero, limit: 15, null: false
      t.string :complemento, limit: 100

      t.timestamps
    end
    add_index :people, :cpf_cnpj, unique: true
  end
end
