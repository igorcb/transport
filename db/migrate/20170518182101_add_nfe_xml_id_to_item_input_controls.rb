class AddNfeXmlIdToItemInputControls < ActiveRecord::Migration[5.0]
  def change
    add_reference :item_input_controls, :nfe_xml, index: true
  end
end
