class AddCarrierToOrdemServices < ActiveRecord::Migration[5.0]
  def change
    add_column :ordem_services, :carrier_id, :integer
  end
end
