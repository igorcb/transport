class AddCountBoardingToOrdemService < ActiveRecord::Migration[5.1]
  def change
    add_column :ordem_services, :count_boarding, :integer, default: 0
    add_column :ordem_services, :declined, :integer, default: 0
  end

  def data
    OrdemService.update_all(count_boarding: 0, declined: 0)
  end
end
