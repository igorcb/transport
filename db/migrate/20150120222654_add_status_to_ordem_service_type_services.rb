class AddStatusToOrdemServiceTypeServices < ActiveRecord::Migration[5.0]
  def change
    add_column :ordem_service_type_services, :status, :integer, default: 0
  end
end
