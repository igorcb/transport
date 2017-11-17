class AddFantasiaToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :fantasia, :string
  end

  def data
    Company.update_all(fantasia: "FANTASIA")
  end  
end
