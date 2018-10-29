class AddValueBoardingToBoardings < ActiveRecord::Migration[5.0]
  def change
    add_column :boardings, :value_boarding, :decimal, precision: 10, scale: 2
  end
end
