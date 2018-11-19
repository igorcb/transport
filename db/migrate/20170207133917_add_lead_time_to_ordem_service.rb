class AddLeadTimeToOrdemService < ActiveRecord::Migration[5.0]
  def change
    add_column :ordem_services, :lead_time, :date
    add_column :ordem_services, :date_otif, :date
  end
end
