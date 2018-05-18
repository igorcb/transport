class AddPlaceToNfeXmls < ActiveRecord::Migration
  def change
    add_column :nfe_xmls, :place, :string
  end
end
