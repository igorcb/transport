class AddTipoToTypeService < ActiveRecord::Migration[5.0]
  def change
    add_column :type_services, :tipo, :integer, default:0
  end
end
