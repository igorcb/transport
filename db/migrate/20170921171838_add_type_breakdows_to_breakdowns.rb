class AddTypeBreakdowsToBreakdowns < ActiveRecord::Migration[5.0]
  def change
    add_reference :breakdowns, :breakdown, polymorphic: true, index: true
  end
end
