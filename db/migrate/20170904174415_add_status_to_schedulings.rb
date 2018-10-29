class AddStatusToSchedulings < ActiveRecord::Migration[5.0]
  def change
    add_column :schedulings, :status, :integer, default: 0
  end
end
