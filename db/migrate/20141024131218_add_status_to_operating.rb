class AddStatusToOperating < ActiveRecord::Migration[5.0]
  def change
    add_column :operatings, :status, :integer
  end
end
