class InternalCommentsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create
  	
    
    case params[:internal_comment][:comment_type]
      when "OrdemService" then 
        @ordem_service = OrdemService.find(params[:internal_comment][:comment_id])
        @comment = @ordem_service.internal_comments.build(internal_comment_params)
      when "Task" then 
        @task = Task.find(params[:internal_comment][:comment_id])
        @comment = @task.internal_comments.build(internal_comment_params)
    end

    @comment.email = current_user.email
    if @comment.save
      @task.send_email_employee_and_requester if @task.present?
      flash[:success] = "Internal Comment created!"
      case params[:internal_comment][:comment_type]
        when "OrdemService" then redirect_to ordem_service_path (@ordem_service)
        when "Task" then redirect_to task_path (@task)
      end
    else
      flash[:danger] = "Error Internal Comment!"
      case params[:internal_comment][:comment_type]
        when "OrdemService" then redirect_to ordem_service_path (@ordem_service)
        when "Task" then redirect_to task_path (@task)
      end
    end      
  end

  private
    def internal_comment_params
      params.require(:internal_comment).permit(:comment_id, :content, :comment_type)
    end

end
