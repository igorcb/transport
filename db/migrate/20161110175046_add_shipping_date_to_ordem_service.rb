class AddShippingDateToOrdemService < ActiveRecord::Migration[5.0]
  def change
    add_column :ordem_services, :date_shipping, :date
  end
end
