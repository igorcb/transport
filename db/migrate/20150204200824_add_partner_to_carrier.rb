class AddPartnerToCarrier < ActiveRecord::Migration
  def change
    add_column :carriers, :partner, :boolean
  end
end
