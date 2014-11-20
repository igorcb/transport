class AddTipoToTypeService < ActiveRecord::Migration
  def change
    add_column :type_services, :tipo, :integer, default:0
  end
end
