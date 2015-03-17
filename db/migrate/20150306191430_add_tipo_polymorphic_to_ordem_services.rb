class AddTipoPolymorphicToOrdemServices < ActiveRecord::Migration
  def change
		add_column :ordem_services, :ordem_service_type, :string
  end
end
