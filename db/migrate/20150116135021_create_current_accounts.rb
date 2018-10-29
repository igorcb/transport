class CreateCurrentAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :current_accounts do |t|
      t.references :cash_account, index: true
      t.date :data, index: true, null: false
      t.decimal :valor, null: false
      t.integer :tipo, null: false
      t.string :historico, limit: 250, null: false

      t.timestamps
    end
  end
end
