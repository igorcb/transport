class CommentsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def create
    @model = find_model
    case params[:comment][:comment_type]
      when "OrdemService" then result = false
      when "Occurrence" then result = false
      when "Boarding" then 
        if params[:nfe].blank?
          flash[:danger] = "Select at least one nfe to generate ocurrence."
          redirect_to comments_boarding_path(@model)
          return
        elsif params[:comment][:title].blank?
          flash[:danger] = "Select the type of occurrence."
          redirect_to comments_boarding_path(@model)
          return
        end
      when "InputControl" then 
        if params[:nfe].blank?
          flash[:danger] = "Select at least one nfe to generate ocurrence."
          redirect_to comments_input_control_path(@model)
          return
        elsif @model.billing_client.blank?
          flash[:danger] = "Select billing client."
          redirect_to comments_input_control_path(@model)
          return
        elsif @model.billing_client.emails.type_sector(Sector::TypeSector::REGISTROS_OCORRENCIA).blank?
          flash[:danger] = "There is no email registered for the billing client."
          redirect_to comments_input_control_path(@model)
          return
        elsif params[:comment][:title].blank?
          flash[:danger] = "Select the type of occurrence."
          redirect_to comments_input_control_path(@model)
          return
        end
    end

    ids = OrdemService.get_hash_ids(params[:nfe][:ids])
		@comment = @model.comments.build(comment_params)
    @comment.email_origem = current_user.email
    @comment.comment_type = params[:comment][:comment_type]
    @comment.observation = ids.to_s

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
      params.require(:comment).permit(:comment_id, :email_destino, :content, :comment_type, :title, :observation)
    end

    def find_model
      case params[:comment][:comment_type]
        when "OrdemService" then @model = OrdemService.find(params[:comment][:comment_id])
        when "Occurrence" then @model = Occurrence.find(params[:comment][:comment_id])
        when "Boarding" then @model = Boarding.find(params[:comment][:comment_id])
        when "InputControl" then @model = InputControl.find(params[:comment][:comment_id])
      end
    end

    def redirect_to_model
      case params[:comment][:comment_type] 
        when "OrdemService" then redirect_to ordem_service_path (@model)
        when "Occurrence" then redirect_to occurrence_path (@model)
        when "Boarding" then redirect_to boarding_path (@model)
        when "InputControl" then redirect_to input_control_path (@model)
      end
    end

    def validations_model
      puts ">>>>>>>>>>>>>>>>>>> validar campos"
      case params[:comment][:comment_type]
        when "OrdemService" then validation_ordem_service
        when "Occurrence" then validation_ocurrences
        when "Boarding" then validation_boarding
      end
    end

    def validation_boarding
      if params[:nfe].blank?
        puts ">>>>>>>>>>>>>>>>>>>>> entrou "
        flash[:danger] = "Select at least one nfe to generate ocurrence."
        redirect_to boarding_path (@model)
        return
      end
    end

    def validation_ordem_service
      
    end

    def validation_ocurrences
      
    end

end
