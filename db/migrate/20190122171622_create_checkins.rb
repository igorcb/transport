class CreateCheckins < ActiveRecord::Migration[5.1]
  def change
    create_table :checkins do |t|
      t.string :driver_cpf
      t.string :driver_name
      t.integer :operation
      t.integer :status

      t.timestamps
    end
  end
end
