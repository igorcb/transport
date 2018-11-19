class AddOperObservationToBoardings < ActiveRecord::Migration[5.0]
  def change
    add_column :boardings, :oper_observation, :text
  end
end
