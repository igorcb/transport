class AddTipoPolymorphicToOrdemServices < ActiveRecord::Migration[5.0]
  def change
		add_column :ordem_services, :ordem_service_type, :string
  end
end
