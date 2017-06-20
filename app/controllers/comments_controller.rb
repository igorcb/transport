class CommentsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create
    @model = find_model
    ids = OrdemService.get_hash_ids(params[:nfe][:ids])
		@comment = @model.comments.build(comment_params)
    @comment.email_origem = current_user.email
    @comment.comment_type = params[:comment][:comment_type]

    if @comment.save
      puts ">>>>>>>>>>>>> comentario salvo, esperando o envio do email. Model: #{@model.class}"
      @comment.send_notification_email(@model)
      flash[:success] = "Comment created!"
      redirect_to_model
    else
      flash[:danger] = "Error Comment!"
      redirect_to_model
    end

  end

  private
    def comment_params
      params.require(:comment).permit(:comment_id, :email_destino, :content, :comment_type)
    end

    def find_model
      case params[:comment][:comment_type]
        when "OrdemService" then @model = OrdemService.find(params[:comment][:comment_id])
        when "Occurrence" then @model = Occurrence.find(params[:comment][:comment_id])
        when "Boarding" then @model = Boarding.find(params[:comment][:comment_id])
      end
    end

    def redirect_to_model
      case params[:comment][:comment_type] 
        when "OrdemService" then redirect_to ordem_service_path (@model)
        when "Occurrence" then redirect_to occurrence_path (@model)
        when "Boarding" then redirect_to boarding_path (@model)
      end
    end

end
