class DropFieldsToControlPalletes < ActiveRecord::Migration[5.1]
  def up
    remove_column :control_pallets, :nfe
    remove_column :control_pallets, :nfd
    remove_column :control_pallets, :nfe_original
    remove_column :control_pallets, :nfd_original
    remove_column :control_pallets, :generate_ordem_service
    remove_column :control_pallets, :peso
    remove_column :control_pallets, :volume

    remove_column :control_pallets, :input_control_id
    remove_column :control_pallets, :carrier_id
    remove_column :control_pallets, :client_id

    add_reference :control_pallets, :responsible, polymorphic: true
    add_column :control_pallets, :type_product, :integer
  end

  def down
    remove_column :control_pallets, :responsible_type
    remove_column :control_pallets, :responsible_id
    remove_column :control_pallets, :type_product_id, :integer

    add_column :control_pallets, :nfe, :string, limit: 255
    add_column :control_pallets, :nfd, :string, limit: 255
    add_column :control_pallets, :nfe_original, :string, limit: 255
    add_column :control_pallets, :nfd_original, :string, limit: 255
    add_column :control_pallets, :generate_ordem_service, :boolean
    add_column :control_pallets, :peso, :decimal, precision: 10, :scale => 3
    add_column :control_pallets, :volume, :decimal, precision: 10, :scale => 3

    add_reference :control_pallets, :input_control, foreign_key: true
    add_reference :control_pallets, :carrier, foreign_key: true
    add_reference :control_pallets, :client, foreign_key: true
  end
end
