class AddClientToClientsPallets < ActiveRecord::Migration
  def change
    add_reference :clients_pallets, :source_client, foreign_key: {to_table: :users }  
  end
end
