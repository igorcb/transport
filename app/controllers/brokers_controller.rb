class BrokersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_broker, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html

  def index
    @brokers = Broker.all
    respond_with(@brokers)
  end

  def show
    respond_with(@broker)
  end

  def new
    @broker = Broker.new
    respond_with(@broker)
  end

  def edit
  end

  def create
    @broker = Broker.new(broker_params)
    respond_to do |format|
      if @broker.save
        format.html { redirect_to @broker, flash: { success: "Broker was successfully created." } }
        format.json { render action: 'show', status: :created, location: @broker }
      else
        format.html { render action: 'new' }
        format.json { render json: @broker.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    respond_to do |format|
      if @broker.update(broker_params)
        format.html { redirect_to @broker, flash: { success: "Broker was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @broker.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @broker.destroy
    respond_with(@broker)
  end

  private
    def set_broker
      @broker = Broker.find(params[:id])
    end

    def broker_params
      params.require(:broker).permit(:cnpj, :name)
    end
end
