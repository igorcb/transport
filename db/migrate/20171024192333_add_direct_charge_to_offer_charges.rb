class AddDirectChargeToOfferCharges < ActiveRecord::Migration[5.0]
  def change
    add_reference :offer_charges, :direct_charge, index: true
  end
end
