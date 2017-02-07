class AddLeadTimeToOrdemService < ActiveRecord::Migration
  def change
    add_column :ordem_services, :lead_time, :date
    add_column :ordem_services, :date_otif, :date
  end
end
