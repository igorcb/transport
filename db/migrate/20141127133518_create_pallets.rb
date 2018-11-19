class CreatePallets < ActiveRecord::Migration[5.0]
  def change
    create_table :pallets do |t|
      t.references :client, index: true
      t.date :data_agendamento, null: false
      t.integer :qtde, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
