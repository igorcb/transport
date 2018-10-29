class AddStretchRouteToOrdemServiceTypeServices < ActiveRecord::Migration[5.0]
  def change
    add_reference :ordem_service_type_services, :stretch_route, index: true
  end
end
