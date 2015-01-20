class AddTypeServiceToSubCostCenters < ActiveRecord::Migration
  def change
    add_reference :sub_cost_centers, :type_service, index: true
  end
end
