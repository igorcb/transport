class AddValores1500ToClient < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :valor_peso_1500, :decimal, precision: 10, scale: 2
  end
end
