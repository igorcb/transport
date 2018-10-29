class AddTypeServiceToSubCostCenters < ActiveRecord::Migration[5.0]
  def change
    add_reference :sub_cost_centers, :type_service, index: true
  end
end
