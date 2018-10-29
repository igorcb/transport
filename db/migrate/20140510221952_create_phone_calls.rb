class CreatePhoneCalls < ActiveRecord::Migration[5.0]
  def change
    create_table :phone_calls do |t|
      t.string :nome, limit: 100, null: false
      t.string :telefone, limit: 10, null: false
      t.string :email, limit: 100, null: false
      t.decimal :valor, precision: 10, scale: 2, null: false
      t.integer :type_service_id, null: false
      t.foreign_key :type_services
      t.text :assunto, null: false

      t.timestamps
    end
  end
end
