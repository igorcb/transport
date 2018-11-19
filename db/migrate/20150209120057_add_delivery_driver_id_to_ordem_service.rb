class AddDeliveryDriverIdToOrdemService < ActiveRecord::Migration[5.0]
  def change
    add_column :ordem_services, :delivery_driver_id, :integer, index: true
  end
end
