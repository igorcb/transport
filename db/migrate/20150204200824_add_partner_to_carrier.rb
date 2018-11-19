class AddPartnerToCarrier < ActiveRecord::Migration[5.0]
  def change
    add_column :carriers, :partner, :boolean
  end
end
