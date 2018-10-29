class AddQtdeToOrdemServiceTypeServices < ActiveRecord::Migration[5.0]
  def change
    add_column :ordem_service_type_services, :qtde, :integer, default: 0
    add_column :ordem_service_type_services, :qtde_recebida, :integer, default: 0
  end
end
