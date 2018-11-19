class AddPisConfinsToStretchRoutes < ActiveRecord::Migration[5.0]
  def change
    add_column :stretch_routes, :pis_cofins, :decimal, precision: 10, scale: 2, default: 0
  end
end
