class AddInsurerToBoardings < ActiveRecord::Migration[5.0]
  def change
    add_reference :boardings, :insurer, index: true
  end
end
