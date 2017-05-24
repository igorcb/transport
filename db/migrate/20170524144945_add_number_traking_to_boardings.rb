class AddNumberTrakingToBoardings < ActiveRecord::Migration
  def change
    add_column :boardings, :number_tranking, :string
  end
end
