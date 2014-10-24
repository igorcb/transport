class CreateOperatingServices < ActiveRecord::Migration
  def change
    create_table :operating_services do |t|
      t.references :operating, index: true
      t.references :type_service, index: true
      t.decimal :valor, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
