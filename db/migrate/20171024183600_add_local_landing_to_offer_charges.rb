class AddLocalLandingToOfferCharges < ActiveRecord::Migration
  def change
    add_column :offer_charges, :local_landing, :string
  end
end
