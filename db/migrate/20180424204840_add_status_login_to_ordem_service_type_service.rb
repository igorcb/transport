class AddStatusLoginToOrdemServiceTypeService < ActiveRecord::Migration[5.0]
  def change
    add_column :ordem_service_type_services, :status_login, :integer
  end
end
