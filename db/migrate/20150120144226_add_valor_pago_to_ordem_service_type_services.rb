class AddValorPagoToOrdemServiceTypeServices < ActiveRecord::Migration
  def change
    add_column :ordem_service_type_services, :valor_pago, :decimal, precision: 10, scale: 2
  end
end
