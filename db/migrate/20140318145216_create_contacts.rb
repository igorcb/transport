class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.integer :tipo, null: false
      t.string :nome, limit: 30, null: false
      t.string :fone, limit: 15
      t.string :complemento, limit: 100
      t.integer :contact_id
      t.string :contact_type
      
      t.timestamps
    end
  end
end
