class AddLocalLandingToOfferCharges < ActiveRecord::Migration[5.0]
  def change
    add_column :offer_charges, :local_landing, :string
  end
end
