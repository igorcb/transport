class RenameClientTablePriceId < ActiveRecord::Migration[5.0]
  def change
    change_table :ordem_services do |t|
      t.rename :client_table_prince_id, :client_table_price_id
    end  	
  end
end
