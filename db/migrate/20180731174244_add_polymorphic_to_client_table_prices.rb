class AddPolymorphicToClientTablePrices < ActiveRecord::Migration
  def change
    add_reference :client_table_prices, :client_table_price, polymorphic: true, index: {:name => "idx_client_table_prices_polymorphic"}
  end
end
