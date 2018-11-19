class SubjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subject, only: [:new, :show, :edit, :update, :destroy]
  load_and_authorize_resource
  respond_to :html

	def show

	end

	def new
		@subject = @meeting.subjects.build
	end

	def edit

	end


  def create
 		@meeting = Meeting.find(params[:meeting_id])
		@subject = @meeting.subjects.build(subject_params)
    @subject.created_user_id = current_user.id
    respond_to do |format|
      if @subject.save
        format.html { redirect_to [@meeting, @subject], flash: { success: "Subject was successfully created." } }
        format.json { render action: 'show', status: :created, location: @subject }
      else
        format.html { render action: 'new' }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end    
  end	

  def update
  	@subject.updated_user_id = current_user.id
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to [@meeting, @subject], flash: { success: "Subject was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  	def set_subject
  		@meeting = Meeting.find(params[:meeting_id])
  		@subject = @meeting.subjects.where(id: params[:id]).first
  	end

  	def subject_params
  		params.require(:subject).permit(:title, :time_meeting, :responsible)
  	end
end
