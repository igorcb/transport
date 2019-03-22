class AddCarrierToNfeXmls < ActiveRecord::Migration[5.1]
  def change
    add_reference :nfe_xmls, :carrier, foreign_key: true
  end
end
