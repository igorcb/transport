class AddFreeTimeToSchedulings < ActiveRecord::Migration[5.0]
  def change
    add_column :schedulings, :free_time, :date
  end
end
