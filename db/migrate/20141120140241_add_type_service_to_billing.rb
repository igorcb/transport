class AddTypeServiceToBilling < ActiveRecord::Migration
  def change
    add_reference :billings, :type_service, index: true
  end
end
