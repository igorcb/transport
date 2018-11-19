class CreateEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :emails do |t|
      t.string :setor, limit: 40, null: false
      t.string :contato, limit: 60, null: false
      t.string :email, limit: 100, null: false
      t.integer :email_id
      t.string :email_type

      t.timestamps
    end
  end
end
