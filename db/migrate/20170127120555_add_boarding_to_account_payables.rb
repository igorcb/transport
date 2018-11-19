class AddBoardingToAccountPayables < ActiveRecord::Migration[5.0]
  def change
    add_reference :account_payables, :boarding, index: true
  end
end
