class AddUserToClientRequirements < ActiveRecord::Migration
  def change
    add_reference :client_requirements, :created_user, foreign_key: {to_table: :users }
    add_reference :client_requirements, :updated_user, foreign_key: {to_table: :users }
  end
end
