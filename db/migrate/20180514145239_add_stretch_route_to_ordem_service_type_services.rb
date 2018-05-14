class AddStretchRouteToOrdemServiceTypeServices < ActiveRecord::Migration
  def change
    add_reference :ordem_service_type_services, :stretch_route, index: true
  end
end
