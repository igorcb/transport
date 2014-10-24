class AddStatusToOperating < ActiveRecord::Migration
  def change
    add_column :operatings, :status, :integer
  end
end
