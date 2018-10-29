class CreateAccountReceivables < ActiveRecord::Migration[5.0]
  def change
    create_table :account_receivables do |t|
      t.references :client, index: true
      t.references :cost_center, index: true
      t.references :sub_cost_center, index: true
      t.references :historic, index: true
      t.date :data_vencimento, index: true, null: false
      t.string :documento, limit: 20, index: true, null: false
      t.decimal :valor, :precision => 10, :scale => 2, null: false, default: 0
      t.text :observacao
      t.integer :status, null: false, default: 0
      t.references :ordem_service, index: true

      t.timestamps
    end
  end
end
