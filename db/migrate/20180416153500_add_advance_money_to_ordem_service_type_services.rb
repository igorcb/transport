class AddAdvanceMoneyToOrdemServiceTypeServices < ActiveRecord::Migration[5.0]
  def change
    add_column :ordem_service_type_services, :advance_money_number, :string
  end
end
