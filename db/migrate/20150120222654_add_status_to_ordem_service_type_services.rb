class AddStatusToOrdemServiceTypeServices < ActiveRecord::Migration
  def change
    add_column :ordem_service_type_services, :status, :integer, default: 0
  end
end
