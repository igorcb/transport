class CreateOrdemServiceTypeServices < ActiveRecord::Migration[5.0]
  def change
    create_table :ordem_service_type_services do |t|
      t.references :ordem_service, index: true
      t.references :type_service, index: true
      t.decimal :valor

      t.timestamps
    end
  end
end
