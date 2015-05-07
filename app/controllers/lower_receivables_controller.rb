class LowerReceivablesController < ApplicationController
  def destroy
		@lower = LowerAccountReceivable.find(params[:id])
		@account_receivable = AccountReceivable.find(@lower.account_receivable)
		@lower.destroy
		@account_receivable.check_balance
    respond_to do |format|
      format.html { redirect_to account_receivable_path(@account_receivable) }
      format.json { head :no_content }
    end		
	end
end
