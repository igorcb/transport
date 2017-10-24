class AddOfferChargeToDirectCharges < ActiveRecord::Migration
  def change
    add_reference :direct_charges, :offer_charge, index: true
  end
end
