class SchedulingsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_scheduling, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  respond_to :html

  def index
    @q = Scheduling.where(status: -1).search(params[:query])
    @schedulings = Scheduling.the_day
    respond_with(@schedulings)
  end

  def show
    respond_with(@scheduling)
  end

  def new
    @scheduling = Scheduling.new
    respond_with(@scheduling)
  end

  def edit
  end

  def create
    @scheduling = Scheduling.new(scheduling_params)
    #-respond_with(@scheduling)
    respond_to do |format|
      if @scheduling.save
        format.html { redirect_to @scheduling, flash: { success: "Scheduling was successfully created." } }
        format.json { render action: 'show', status: :created, location: @scheduling }
      else
        format.html { render action: 'new' }
        format.json { render json: @owner.scheduling, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @scheduling.update(scheduling_params)
        format.html { redirect_to @scheduling, flash: { success: "Scheduling was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @scheduling.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @scheduling.destroy
    respond_with(@scheduling)
  end

  def search
    @q = Scheduling.search(params[:query])
    @schedulings = @q.result
    respond_with(@schedulings) do |format|
     format.js
    end
  end


  private
    def set_scheduling
      @scheduling = Scheduling.find(params[:id])
    end

    def scheduling_params
      params.require(:scheduling).permit(:client, :type_modal, :date_scheduling, :time_scheduling, :date_scheduling_client, 
        :time_scheduling_client, :container, :obs, :free_time,
        nfe_xmls_attributes: [:asset, :equipamento, :id, :_destroy],
        )
    end
end
