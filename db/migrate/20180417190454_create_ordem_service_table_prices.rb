class CreateOrdemServiceTablePrices < ActiveRecord::Migration[5.0]
  def change
    create_table :ordem_service_table_prices do |t|
      t.references :ordem_service, index: {name: 'os_table_price_os_type_service'}
      t.references :type_service, index: {name: 'os_type_service_os_type_service'}
      t.references :ordem_service_type_service, index: {name: 'table_price_os_service'}
      t.references :client_table_price, index: {name: 'os_table_price_client_table_price'}
     
      t.decimal :iss_tax, precision: 20, scale: 4, default: 0
      t.decimal :iss_value, precision: 20, scale: 4, default: 0
      t.decimal :margin_lucre_tax, precision: 20, scale: 4, default: 0
      t.decimal :margin_lucre_value, precision: 20, scale: 4, default: 0
      t.decimal :total_service, precision: 20, scale: 4, default: 0

      t.timestamps
    end
  end
end
