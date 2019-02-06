class SealingwaxesController < ApplicationController
  def create
    @boarding = Boarding.find(params[:boarding][:id])
    @sealingwax = @boarding.sealings.build(sealingwax_params)
    if @sealingwax.save
      flash[:success] = "Sealing created!"
      redirect_to boarding_path(@boarding)
    else
      flash[:danger] = "Error Sealing!"
      redirect_to boarding_path(@boarding)
    end
  end

  private

  def sealingwax_params
    params.require(:sealingwax).permit(:number)
  end
end
