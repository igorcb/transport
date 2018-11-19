class CreateAccountBanks < ActiveRecord::Migration[5.0]
  def change
    create_table :account_banks do |t|
      t.string :banco, limit: 3, null: false 
      t.string :agencia, limit: 6, null: false 
      t.string :conta_corrente, limit: 10, null: false 
      t.string :favorecido, limit: 100, null: false 
      t.string :cpf_cnpj, limit: 18
      t.integer :account_id
      t.string :contact_type

      t.timestamps
    end
  end
end
