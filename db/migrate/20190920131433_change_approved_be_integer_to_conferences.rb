class ChangeApprovedBeIntegerToConferences < ActiveRecord::Migration[5.1]
  def change
    change_column :conferences, :approved, :string
  end
end
