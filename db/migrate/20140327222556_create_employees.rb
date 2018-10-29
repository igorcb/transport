class CreateEmployees < ActiveRecord::Migration[5.0]
  def change
    create_table :employees do |t|
      t.string :cpf, limit: 14, null: false
      t.string :nome, limit: 100, null: false
      t.string :apelido, limit: 100, null: false
      t.string :endereco, limit: 100, null: false
      t.string :numero, limit: 20, null: false
      t.string :complemento, limit: 100
      t.string :bairro, limit: 100, null: false
      t.string :cidade, limit: 100, null: false
      t.string :estado, limit: 2, null: false
      t.string :cep, limit: 10, null: false
      t.integer :tipo, null: false

      t.timestamps
    end
  end
end
