class AddOfferChargeToDirectCharges < ActiveRecord::Migration[5.0]
  def change
    add_reference :direct_charges, :offer_charge, index: true
  end
end
