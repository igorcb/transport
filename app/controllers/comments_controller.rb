class CommentsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create
    case params[:comment][:comment_type]
      when "OrdemService" then @model = OrdemService.find(params[:comment][:comment_id])
      when "Occurrence" then @model = Occurrence.find(params[:comment][:comment_id])
    end
		@comment = @model.comments.build(comment_params)
    @comment.email_origem = current_user.email
    @comment.comment_type = params[:comment][:comment_type]
    if @comment.save
      #@comment.send_notification_email
      flash[:success] = "Comment created!"
      case params[:comment][:comment_type] 
        when "OrdemService" then redirect_to ordem_service_path (@model)
        when "Occurrence" then redirect_to occurrence_path (@model)
      end
    else
      flash[:danger] = "Error Comment!"
      redirect_to ordem_service_path (@model)
    end

  end

  private
    def comment_params
      params.require(:comment).permit(:comment_id, :email_destino, :content, :comment_type)
    end

end
