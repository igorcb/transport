class AddClientTablePriceToInputControls < ActiveRecord::Migration[5.0]
  def change
    add_reference :input_controls, :client_table_price, index: true
  end
end
