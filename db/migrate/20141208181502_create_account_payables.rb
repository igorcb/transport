class CreateAccountPayables < ActiveRecord::Migration[5.0]
  def change
    create_table :account_payables do |t|
      t.references :supplier, index: true
      t.references :cost_center, index: true
      t.references :sub_cost_center, index: true
      t.references :historic, index: true
      t.date :data_vencimento, index: true, null: false
      t.string :documento, limit: 20, index: true, null: false
      t.decimal :valor, :precision => 10, :scale => 2, null: false, default: 0
      t.text :observacao, null: false
      t.integer :status

      t.timestamps
    end
  end
end
