class ChangeStatusDefaultToInputControls < ActiveRecord::Migration
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
