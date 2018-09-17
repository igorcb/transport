class InsurersController < ApplicationController
  before_action :set_insurer, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @insurers = Insurer.all
    respond_with(@insurers)
  end

  def show
    respond_with(@insurer)
  end

  def new
    @insurer = Insurer.new
    respond_with(@insurer)
  end

  def edit
  end

  def create
    @insurer = Insurer.new(insurer_params)
    @insurer.save
    respond_with(@insurer)
  end

  def update
    @insurer.update(insurer_params)
    respond_with(@insurer)
  end

  def destroy
    @insurer.destroy
    respond_with(@insurer)
  end

  private
    def set_insurer
      @insurer = Insurer.find(params[:id])
    end

    def insurer_params
      params.require(:insurer).permit(:cnpj, :name)
    end
end
