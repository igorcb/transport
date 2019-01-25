class ChangeOperationToCheckins < ActiveRecord::Migration[5.1]
  def change
    rename_column :checkins, :operation, :operation_type
  end
end
