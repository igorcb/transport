class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :cpf_cnpj, limit: 18, null: false
      t.string :nome, limit: 100, null: false
      t.string :fantasia, limit: 100, null: false
      t.string :inscricao_estadual, limit: 20
      t.string :inscricao_municipal, limit: 20
      t.string :endereco, limit: 100, null: false
      t.string :numero, limit: 20, null: false
      t.string :complemento, limit: 100
      t.string :bairro, limit: 100, null: false
      t.string :cidade, limit: 100, null: false
      t.string :estado, limit: 2, null: false
      t.string :cep, limit: 10, null: false
      t.integer :tipo_pessoa, null: false
      
      t.timestamps
    end
  end
end
