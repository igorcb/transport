class AddPisConfinsToStretchRoutes < ActiveRecord::Migration
  def change
    add_column :stretch_routes, :pis_cofins, :decimal, precision: 10, scale: 2, default: 0
  end
end
