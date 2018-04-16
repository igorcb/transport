class AddAdvanceMoneyToOrdemServiceTypeServices < ActiveRecord::Migration
  def change
    add_column :ordem_service_type_services, :advance_money_number, :string
  end
end
