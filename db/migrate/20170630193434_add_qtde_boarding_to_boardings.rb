class AddQtdeBoardingToBoardings < ActiveRecord::Migration
  def change
    add_column :boardings, :qtde_boarding, :integer
  end
end
