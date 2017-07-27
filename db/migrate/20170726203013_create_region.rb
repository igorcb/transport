class CreateRegion < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :name
    end
  end

  def data
  	Region.create!(name: "Norte")
  	Region.create!(name: "Nordeste")
  	Region.create!(name: "Sudeste")
  	Region.create!(name: "Sul")
  	Region.create!(name: "Centro-Oeste")
  end
end
