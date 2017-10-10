class Comment < ActiveRecord::Base
  belongs_to :ordem_service, class_name: "OrdemService", foreign_key: "comment_id", polymorphic: true, dependent: :destroy
	belongs_to :boarding, class_name: "Boarding", foreign_key: "comment_id", polymorphic: true, dependent: :destroy
  belongs_to :input_control, class_name: "InputControl", foreign_key: "comment_id", polymorphic: true, dependent: :destroy
  validates :content, presence: true

  
  def type_occurrence_name
    case self.title
      when 0 then "ALTERAÇÃO AGENDAMENTO"
      when 1 then "AVARIA NO RECEBIMENTO EM NOSSO CD"
      when 2 then "AVARIA E FALTA NO RECEBIMENTO EM NOSSO CD"
      when 3 then "CLIENTE RECUSOU A MERCADORIA"
      when 4 then "CLIENTE RECUSOU A NOTA "
      when 5 then "DIVERGÊNCIA NA NOTAS FISCAL"
      when 6 then "FALTA DE PEDIDO"
      when 7 then "FALTA NO RECEBIMENTO EM NOSSO CD"
      when 8 then "SEM PREVISÃO DE DESCARGA"
    end
  end

  def send_notification_email(model)
  	puts ">>>>>>>>>>>>>> send_notification_email. Model: #{model.class}"
  	result = model.class == Boarding
  	puts ">>>>>>>>>>>>>> result: #{result}"
    case model.class.to_s
      when "OrdemService" then CommentMailer.notification(model).deliver!
      when "Occurrence" then CommentMailer.notification(model).deliver!
      when "Boarding" then CommentMailer.notification_boarding(model).deliver!
      when "InputControl" then CommentMailer.notification_input_control(model).deliver!
    end
  end

  def ordem_service
  	OrdemService.find_by(id: self.comment_id)
  end

  def boarding
  	Boarding.find_by(id: self.comment_id)
  end
end
