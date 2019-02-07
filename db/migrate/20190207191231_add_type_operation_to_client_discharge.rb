class AddTypeOperationToClientDischarge < ActiveRecord::Migration[5.1]
  def change
    add_column :client_discharges, :type_operation, :integer
  end
end
