class CreateCashAccounts < ActiveRecord::Migration
  def change
    create_table :cash_accounts do |t|
      t.string :nome, limit: 100
      t.references :bank, index: true
      t.string :agencia, limit: 6
      t.string :conta_corrente, limit: 10
      t.decimal :ted_doc, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
