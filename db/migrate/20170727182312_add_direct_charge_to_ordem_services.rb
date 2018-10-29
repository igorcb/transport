class AddDirectChargeToOrdemServices < ActiveRecord::Migration[5.0]
  def change
    add_reference :ordem_services, :direct_charge, index: true
  end
end
