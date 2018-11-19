class CreateShippers < ActiveRecord::Migration[5.0]
  def change
    create_table :shippers do |t|
      t.string :name
      t.string :cnpj

      t.timestamps
    end
  end
end
