class AddStatusLoginToOrdemServiceTypeService < ActiveRecord::Migration
  def change
    add_column :ordem_service_type_services, :status_login, :integer
  end
end
