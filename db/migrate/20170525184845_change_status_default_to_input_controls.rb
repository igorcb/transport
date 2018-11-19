class ChangeStatusDefaultToInputControls < ActiveRecord::Migration[5.0]
  # def change
  # 	change_column :input_controls, :status, :integer, default: 0
  # end
	def up
	  change_column :input_controls, :status, :integer, null: false, default: 0
	end

	def down
	  change_column :input_controls, :status, :integer
	end  
end
