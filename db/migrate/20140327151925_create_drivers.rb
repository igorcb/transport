class CreateDrivers < ActiveRecord::Migration[5.0]
  def change
    create_table :drivers do |t|
      t.string :cpf, limit: 14, null: false
      t.string :nome, limit: 100, null: false
      t.string :fantasia, limit: 100, null: false
      t.string :endereco, limit: 100, null: false
      t.string :numero, limit: 20, null: false
      t.string :complemento, limit: 100
      t.string :bairro, limit: 100, null: false
      t.string :cidade, limit: 100, null: false
      t.string :estado, limit: 2, null: false
      t.string :cep, limit: 10, null: false
      t.string :rg, limit: 20, null: false
      t.string :orgao_expeditor, limit: 20, null: false
      t.date   :data_emissao_rg, null: false
      t.date   :data_nascimento, null: false
      t.string :municipio_nascimento, limit: 100, null: false
      t.string :estado_nascimento, limit: 2, null: false
      t.string :inss, limit: 20

      t.string :cnh, limit: 20, null: false
      t.string :registro_cnh, limit: 20, null: false
      t.integer :categoria, null: false
      t.date   :validade_cnh, null: false

      t.string :nome_do_pai, limit: 100
      t.string :nome_da_mae, limit: 100

      t.timestamps
    end
  end
end
