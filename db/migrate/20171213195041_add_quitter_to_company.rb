class AddQuitterToCompany < ActiveRecord::Migration[5.0]
def up
    add_attachment :companies, :quitter
  end

  def down
    remove_attachment :companies, :quitter
  end
end
