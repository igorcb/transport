class AddValueBoardingToBoardings < ActiveRecord::Migration
  def change
    add_column :boardings, :value_boarding, :decimal, precision: 10, scale: 2
  end
end
