class AddCarrierToOrdemServices < ActiveRecord::Migration
  def change
    add_column :ordem_services, :carrier_id, :integer
  end
end
