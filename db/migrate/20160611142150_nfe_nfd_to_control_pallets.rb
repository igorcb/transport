class NfeNfdToControlPallets < ActiveRecord::Migration
  def change
    change_table :control_pallets do |t|
		  t.string :nfe, index: true
		  t.string :nfd, index: true
		  t.string :nfe_original, index: true
		  t.string :nfd_original, index: true
	  end
  end
end
