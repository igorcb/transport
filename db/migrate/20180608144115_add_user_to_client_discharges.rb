class AddUserToClientDischarges < ActiveRecord::Migration[5.0]
  def change
    add_reference :client_discharges, :created_user, foreign_key: {to_table: :users }
    add_reference :client_discharges, :updated_user, foreign_key: {to_table: :users }
  end
end
