class AddDeliveryUserToOrdemServices < ActiveRecord::Migration
  def change
  	add_column :ordem_services, :delivery_user_time, :datetime
    add_reference :ordem_services, :delivery_user, foreign_key: {to_table: :users }
  end
end
