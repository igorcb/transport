class AddClientToClientsPallets < ActiveRecord::Migration[5.0]
  def change
    add_reference :clients_pallets, :source_client, foreign_key: {to_table: :users }  
  end
end
