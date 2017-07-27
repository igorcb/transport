class AddDirectChargeToOrdemServices < ActiveRecord::Migration
  def change
    add_reference :ordem_services, :direct_charge, index: true
  end
end
