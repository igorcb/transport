class AddPlaceToNfeXmls < ActiveRecord::Migration[5.0]
  def change
    add_column :nfe_xmls, :place, :string
  end
end
