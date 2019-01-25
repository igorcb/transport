class AddOperationIdToCheckins < ActiveRecord::Migration[5.1]
  def change
    add_column :checkins, :operation_id, :integer
  end
end
