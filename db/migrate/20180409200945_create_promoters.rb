class CreatePromoters < ActiveRecord::Migration
  def change
    create_table :promoters do |t|
      t.string :cpf
      t.string :nome
      t.string :fantasia
      t.string :endereco
      t.string :numero
      t.string :complemento
      t.string :bairro
      t.string :cidade
      t.string :estado
      t.string :cep

      t.timestamps
    end
  end
end
