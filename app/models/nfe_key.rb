class NfeKey < ActiveRecord::Base
  validates :nfe, presence: true, length: { maximum: 20 }, numericality: { only_integer: true }
  validates :chave, length: { is: 44 }, numericality: { only_integer: true }, allow_blank: true
	
	belongs_to :ordem_service, class_name: "OrdemService", foreign_key: "nfe_id", dependent: :destroy#, polymorphic: true
  belongs_to :pallet, class_name: "Pallet", foreign_key: "nfe_id", dependent: :destroy #, polymorphic: true
  
  belongs_to :user_action_inspector_confirmed, class_name: "User", foreign_key: "action_inspector_user_confirmed_id"

  has_one :occurrence

  has_attached_file :asset, :styles => {medium: "300x300>", thumb: "100x100>", mini: "32x32>"}
  has_attached_file :action_inspector
  # has_attached_file :asset,
  # :styles => {:medium => "300x300>", :thumb => "100x100>"},
  # :url => "assets/:class/:attachment/:id/:style/:basename.:extension",
  # :path => ":rails_root/assets/:class/:attachment/:id/:style/:basename.:extension"   
  validates_attachment_content_type :asset, :content_type => /\Aimage\/.*\Z/, allow_blank: true

  module TypeTakeDae
    ABERTO = 1
    PAGO   = 2
  end

  module Retained
    NAO = 0
    SIM = 1
  end

  module TypeMotive
    DIVERGENCIA_NFE = 1
    AVARIA_SOBRA_FALTA = 2
    CLIENTE_QUE_PAGAMENTO = 3
    NAO_HOUVE_PAGAMENTO_DESCARGA = 4
    DANOS_MATERIAIS_CLIENTE = 5
    MOTORISTA_NÃO_ESPEROU_CANHOTO = 6
    VENCIMENTO_BOLETO = 7
    MERCADORIA_VENCIDA = 8
    MERCADORIA_PROBLEMA_PRODUCAO = 9
  end

  def status_nfe
    # =byebug
    result = ''
    if self.ordem_service.data.blank?
      #'QUANDO A DATA DE AGENDAMENTO DA O.S. ESTIVER EM BRANCO'
      return result = "AGUARDANDO AGENDAMENTO"
    end
    if self.ordem_service.data.present?
      #'QUANDO A DATA DE AGENDAMENTO DA O.S. ESTIVER EM BRANCO'
      date = self.ordem_service.data.strftime('%d/%m/%Y')
      result = "PREVISAO DE ENTREGA - #{date}"
    end
    if self.ordem_service.status == "CLIENTE_NAO_RECEBEU"
      #"CRIAR STATUS DE QUE O CLIENTE NÃO RECEBEU A MERCADORIA"
      return result = "CLIENTE NÃO RECEBEU MERCADORIA"
    end
    if self.ordem_service.status == "CHECKIN_CLIENTE"
      #'QUANDO O STATUS DA O.S. ESTIVER EMBARCADO, CRIAR UM NOVO STATUS NA O.S. CHECKIN NO CLIENTE'
      return status = "AGUARDANDO DESCARGAR NO CLIENTE"
    end
    if self.ordem_service.status == OrdemService::TipoStatus::EMBARCADO
      #'QUANDO O STATUS DA O.S. ESTIVER EMBARCADO'
      return result = "MERCADORIA EM ROTA PARA O CLIENTE"
    end
    #(os.status == OrdemService::TipoStatus::FECHADO) or (os.status == OrdemService::TipoStatus::FATURADO)
    if ( (self.ordem_service.status == OrdemService::TipoStatus::ENTREGA_EFETUADA) ||
         (self.ordem_service.status == OrdemService::TipoStatus::FECHADO) ||
         (self.ordem_service.status == OrdemService::TipoStatus::FATURADO) )
      #'ENTREGA EFETUADA' = 'QUANDO A O.S. ESTIVER COM STATUS ENTREGA EFETUADA '
      date = self.ordem_service.data_entrega_servico.strftime('%d/%m/%Y')
      return result = "ENTREGA EFETUADA - #{date}"
    end
    result
    #'AGUARDANDO DESCARGAR NA L7' = 'PEGAR DA REMESSA DE ENTRADA QUANDO A DIGITALIZACAO ESTIVER FINALIZADA SE TIVER GERADO O.S.'

  end

  def motive_name
    case self.motive_id
      when TypeMotive::DIVERGENCIA_NFE then "Divergencia de valores da nota fiscal"
      when TypeMotive::AVARIA_SOBRA_FALTA then "Avaria, Sobra e ou Falta, Inversão de Mercadoria"
      when TypeMotive::CLIENTE_QUE_PAGAMENTO then "Canhoto ficou retido porque o cliente que o pagamento da mercadoria (Avaria, Sobra e ou Falta)"
      when TypeMotive::NAO_HOUVE_PAGAMENTO_DESCARGA then "Não Houve Pagamento da Descarga"
      when TypeMotive::DANOS_MATERIAIS_CLIENTE then "Motorista gerou algum dano (material) para o cliente"
      when TypeMotive::MOTORISTA_NÃO_ESPEROU_CANHOTO then "Motorista não esperou o canhoto"
      when TypeMotive::VENCIMENTO_BOLETO then "Vencimento do boleto"
      when TypeMotive::MERCADORIA_VENCIDA then "Mercadoria vencida"
      when TypeMotive::MERCADORIA_PROBLEMA_PRODUCAO then "Mercadoria com problema de produção"
    end
  end

  def retained_name
    case self.retained 
      when 0 then "Não"
      when 1 then "Sim"
    end
  end

  def is_retained?
    self.retained == Retained::SIM
  end

  def is_image?
    return false unless asset.content_type
    ['image/jpeg', 'image/jpg'].include?(asset.content_type)
  end  
  
  def tesseract_context?
    #%w('CT-e', 'CT-E', 'CTE', 'CTe').each {|str| puts str}
    if self.asset.present?
      img = RTesseract.new(self.asset.path)
      puts ">>>>>>>>>>>>> Img: #{img.to_s}"
      text_img = img.to_s
      text_img.include?(self.nfe) ? true : false
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ['nfe']
  end

  def freight_average
    result = 0.00
    result = self.peso * self.average if self.peso.present? && self.average.present?
    result
  end

  def action_inspector_status_name
    if self.action_inspector_file_name.present?
      "Pago"
    else
      "Em Aberto"
    end
  end

  def action_inspector_status_pay
    self.action_inspector_file_name.present?
  end

  def dae_pending?
    result = false
    if self.take_dae?
      if self.action_inspector_file_name.nil? 
        result = true
      end
    end
    result 
  end

  def self.take_dae(nfe_key)
    ActiveRecord::Base.transaction do
      NfeKey.where(id: nfe_key.id).update_all(take_dae: true)
    end
  end

end

