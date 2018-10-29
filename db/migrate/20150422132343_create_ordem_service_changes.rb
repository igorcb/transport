class CreateOrdemServiceChanges < ActiveRecord::Migration[5.0]
  def change
    create_table :ordem_service_changes do |t|
      t.references :ordem_service, index: true
      t.string :source_cep
      t.string :source_numero
      t.string :source_complemento
      t.string :source_endereco_completo
      t.string :source_endereco
      t.string :source_bairro
      t.string :source_cidade
      t.string :source_estado
      t.string :source_contato
      t.string :target_cep
      t.string :target_numero
      t.string :target_complemento
      t.string :target_endereco_completo
      t.string :target_endereco
      t.string :target_bairro
      t.string :target_cidade
      t.string :target_estado
      t.string :target_contato
      t.string :placa
      t.references :driver, index: true
      t.boolean :compartilhado
      t.decimal :cubagem
      t.decimal :valor_declarado
      t.decimal :valor_total

      t.timestamps
    end
  end
end
