class CreateLowerAccountPayables < ActiveRecord::Migration
  def change
    create_table :lower_account_payables do |t|
      t.references :account_payable, index: true
      t.date :data_pagamento, index: true, null: false
      t.decimal :valor_pago, :precision => 10, :scale => 2, null: false, default: 0
      t.decimal :juros, :precision => 10, :scale => 2, null: false, default: 0
      t.decimal :desconto, :precision => 10, :scale => 2, null: false, default: 0
      t.decimal :total_pago, :precision => 10, :scale => 2, null: false, default: 0

      t.timestamps
    end
  end
end
