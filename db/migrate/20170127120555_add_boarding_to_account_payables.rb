class AddBoardingToAccountPayables < ActiveRecord::Migration
  def change
    add_reference :account_payables, :boarding, index: true
  end
end
