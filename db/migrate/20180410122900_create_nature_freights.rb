class CreateNatureFreights < ActiveRecord::Migration[5.0]
  def change
    create_table :nature_freights do |t|
      t.string :name

      t.timestamps
    end
  end
end
