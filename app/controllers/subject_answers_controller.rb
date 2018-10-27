class SubjectAnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subject_answers, only: [:new, :show, :edit, :update, :destroy]
  load_and_authorize_resource
  respond_to :html

	def show

	end

	def new
		#@subject_answer = @subject.subject_answers.build
	end

  def create
		@meeting = Meeting.find(params[:meeting_id])
		@subject = @meeting.subjects.where(id: params[:subject_id]).first
		@subject_answer = @subject.subject_answers.build(subject_answer_params)
    @subject_answer.created_user_id = current_user.id
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

  private
  	def set_subject_answers
  		@meeting = Meeting.find(params[:meeting_id])
  		@subject = @meeting.subjects.where(id: params[:subject_id]).first
  		@subject_answer = @subject.subject_answers.where(id: params[:id]).first
  	end

  	def subject_answer_params
  		params.require(:subject_answer).permit(:deadline, :responsible, :action)
  	end
end
