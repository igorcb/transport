class AddInputControlToOrdemServices < ActiveRecord::Migration[5.0]
  def change
    add_reference :ordem_services, :input_control, index: true
  end
end
