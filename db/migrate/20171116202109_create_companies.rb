class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.string :razao_social
      t.string :fantasia
      t.string :cnpj
      t.string :inscricao_estadual
      t.string :inscricao_municipal
      t.string :endereco
      t.string :numero
      t.string :complemento
      t.string :bairro
      t.string :cidade
      t.string :estado
      t.string :cep
      t.string :pais
      t.string :phone_first
      t.string :phone_second
      t.text :observacao
      t.attachment :image

      t.timestamps
    end
  end

  def data
    Company.create!(
      razao_social: "EMPRESA",
      cnpj: "00.000.000/0000-00",
      inscricao_estadual: "XXXX",
      inscricao_municipal: "XXXX",
      endereco: "ENDERECO DA EMPRESA",
      numero: "000",
      complemento: "COMPLEMENTO",
      bairro: "BAIRRO",
      cidade: "CIDADE",
      estado: "ESTADO",
      cep: "60.000-000",
      pais: "BRASIL",
      phone_first: "(85) 9.9999.9999",
      phone_second: "(85) 9.9999.9999"
      )
  end  
end
