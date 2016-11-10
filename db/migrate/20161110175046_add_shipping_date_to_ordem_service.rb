class AddShippingDateToOrdemService < ActiveRecord::Migration
  def change
    add_column :ordem_services, :date_shipping, :date
  end
end
