class AddTypeServiceToBilling < ActiveRecord::Migration[5.0]
  def change
    add_reference :billings, :type_service, index: true
  end
end
