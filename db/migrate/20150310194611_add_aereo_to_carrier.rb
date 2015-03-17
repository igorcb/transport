class AddAereoToCarrier < ActiveRecord::Migration
  def change
    add_column :carriers, :aereo, :boolean
    add_column :carriers, :antt, :string, limit: 20
    add_column :carriers, :antt_categoria, :string, limit: 5
  end
end

