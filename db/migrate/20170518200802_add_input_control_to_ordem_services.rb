class AddInputControlToOrdemServices < ActiveRecord::Migration
  def change
    add_reference :ordem_services, :input_control, index: true
  end
end
