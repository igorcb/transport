class AddNfeXmlIdToItemInputControls < ActiveRecord::Migration
  def change
    add_reference :item_input_controls, :nfe_xml, index: true
  end
end
