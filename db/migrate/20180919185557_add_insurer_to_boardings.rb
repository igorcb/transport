class AddInsurerToBoardings < ActiveRecord::Migration
  def change
    add_reference :boardings, :insurer, index: true
  end
end
