class AddQtdeBoardingToBoardings < ActiveRecord::Migration[5.0]
  def change
    add_column :boardings, :qtde_boarding, :integer
  end
end
