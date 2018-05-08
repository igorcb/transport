class AddClientTablePriceToInputControls < ActiveRecord::Migration
  def change
    add_reference :input_controls, :client_table_price, index: true
  end
end
