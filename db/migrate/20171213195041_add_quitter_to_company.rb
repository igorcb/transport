class AddQuitterToCompany < ActiveRecord::Migration
def up
    add_attachment :companies, :quitter
  end

  def down
    remove_attachment :companies, :quitter
  end
end
