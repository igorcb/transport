class AddDeliveryDriverIdToOrdemService < ActiveRecord::Migration
  def change
    add_column :ordem_services, :delivery_driver_id, :integer, index: true
  end
end
