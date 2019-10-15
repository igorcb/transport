class AddBreakdownsUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :input_controls, :breakdown_user, foreign_key: {to_table: :users }
  end
end
