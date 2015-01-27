class LowerPayablesController < ApplicationController
  def destroy
		@lower = LowerAccountPayable.find(params[:id])
		@account_payable = AccountPayable.find(@lower.account_payable)
		@lower.destroy
		@account_payable.check_balance
    respond_to do |format|
      format.html { redirect_to account_payable_path(@account_payable) }
      format.json { head :no_content }
    end		
	end
end
