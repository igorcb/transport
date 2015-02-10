class InternalCommentsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create
  	@ordem_service = OrdemService.find(params[:internal_comment][:comment_id])

  	@comment = @ordem_service.internal_comments.build(internal_comment_params)
    @comment.email = current_user.email
    if @comment.save
      flash[:success] = "Internal Comment created!"
      redirect_to ordem_service_path (@ordem_service)
    else
      flash[:danger] = "Error Internal Comment!"
      redirect_to ordem_service_path (@ordem_service)
    end      
  end

  private
    def internal_comment_params
      params.require(:internal_comment).permit(:comment_id, :content)
    end

end
