class CreateShippers < ActiveRecord::Migration
  def change
    create_table :shippers do |t|
      t.string :name
      t.string :cnpj

      t.timestamps
    end
  end
end
