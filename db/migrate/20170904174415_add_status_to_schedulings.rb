class AddStatusToSchedulings < ActiveRecord::Migration
  def change
    add_column :schedulings, :status, :integer, default: 0
  end
end
