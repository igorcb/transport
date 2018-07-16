class CreateMicroRegions < ActiveRecord::Migration
  def change
    create_table :micro_regions do |t|
      t.string :name

      t.timestamps
    end
  end
end
