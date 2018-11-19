class AddNumberTrakingToBoardings < ActiveRecord::Migration[5.0]
  def change
    add_column :boardings, :number_tranking, :string
  end
end
