class CreateOperatings < ActiveRecord::Migration[5.0]
  def change
    create_table :operatings do |t|
      t.references :driver, index: true
      t.references :client, index: true
      t.date :data_chegada, index: true
      t.string :placa, limit: 10, index: true
      t.string :cte, limit: 20, index: true
      t.string :danfe, limit: 20, index: true
      t.decimal :qtde_volume, precision: 10, scale: 2
      t.decimal :peso, precision: 10, scale: 2
      t.text :observacao
      t.string :chave_cte, limit: 45
      t.string :chave_nfe, limit: 45
      t.string :responsavel_recebimento, limit: 50
      t.text :informacao_agendamento
      t.text :informacao_operacional
      t.string :responsavel_descarga, limit: 50
      t.decimal :valor, precision: 10, scale: 2
      t.integer :fpgto
      t.boolean :avaria
      t.date :data_devolucao
      t.text :motivo_devolucao
      t.string :danfe_devolucao, limit: 42
      t.text :observacao_edvolucao

      t.timestamps
    end
  end
end
