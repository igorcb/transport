class AddFreeTimeToSchedulings < ActiveRecord::Migration
  def change
    add_column :schedulings, :free_time, :date
  end
end
