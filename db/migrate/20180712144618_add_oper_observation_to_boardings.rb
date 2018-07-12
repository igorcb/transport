class AddOperObservationToBoardings < ActiveRecord::Migration
  def change
    add_column :boardings, :oper_observation, :text
  end
end
