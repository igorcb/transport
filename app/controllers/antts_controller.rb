class AnttsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_antt, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html

  def index
    @antts = Antt.all
    respond_with(@antts)
  end

  def show
    @antts_vehicles = AnttsVehicles.new
    respond_with(@antt)
  end

  def new
    @antt = Antt.new
    respond_with(@antt)
  end

  def edit
  end

  def create
    @antt = Antt.new(antt_params)
    @antt.save
    respond_with(@antt)
  end

  def update
    @antt.update(antt_params)
    respond_with(@antt)
  end

  def destroy
    @antt.destroy
    respond_with(@antt)
  end

  private
    def set_antt
      @antt = Antt.find(params[:id])
    end

    def antt_params
      params.require(:antt).permit(:rntrc, :cpf_cnpj, :name, :date_expiration)
    end
end
