class CreateMicroRegionsCities < ActiveRecord::Migration[5.0]
  def change
    create_table :micro_regions_cities do |t|
      t.references :micro_region, index: true
      t.references :city, index: true

      t.timestamps
    end
  end
end
