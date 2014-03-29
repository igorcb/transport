class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :nome, limit: 30, null: false
      t.integer :tipo, null: false
      t.string :fone, limit: 15
      t.string :complemento, limit: 100
      t.integer :person_id, null: false
      t.foreign_key :persons
      
      t.timestamps
    end
  end
end
