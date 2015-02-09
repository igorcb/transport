class CommentsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create
  	@ordem_service = OrdemService.find(params[:comment][:comment_id])
		@comment = @ordem_service.comments.build(comment_params)
    @comment.email_origem = current_user.email
    @comment.comment_type = 'OrdemService'
    if @comment.save
      flash[:success] = "Comment created!"
      redirect_to ordem_service_path (@ordem_service)
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:comment_id, :email_destino, :content)
    end

end
