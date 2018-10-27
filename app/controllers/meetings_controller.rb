class MeetingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_meeting, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html

  def index
    @meetings = Meeting.all
  end

  def show
    
  end

  def new
    @meeting = Meeting.new
    
  end

  def edit
  end

  def create
    @meeting = Meeting.new(meeting_params)
    @meeting.created_user_id = current_user.id
    respond_to do |format|
      if @meeting.save
        format.html { redirect_to @meeting, flash: { success: "Meeting was successfully created." } }
        format.json { render action: 'show', status: :created, location: @meeting }
      else
        format.html { render action: 'new' }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      @meeting.updated_user_id = current_user.id
      if @meeting.update(meeting_params)
        format.html { redirect_to @meeting, flash: { success: 'Meeting was successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @meeting.destroy
    respond_with(@meeting)
  end

  private
    def set_meeting
      @meeting = Meeting.find(params[:id])
    end

    def meeting_params
      params.require(:meeting).permit(:date_event, :time_event, :local, :summoned, :facilitator, :secretary, :objective,
        assets_attributes: [:asset, :id, :_destroy]
        
        )
    end
end
