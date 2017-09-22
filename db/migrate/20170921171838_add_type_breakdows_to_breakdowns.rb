class AddTypeBreakdowsToBreakdowns < ActiveRecord::Migration
  def change
    add_reference :breakdowns, :breakdown, polymorphic: true, index: true
  end
end
