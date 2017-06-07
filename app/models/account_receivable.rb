class AccountReceivable < ActiveRecord::Base
  validates :client_id, presence: true
  validates :cost_center_id, presence: true
  validates :sub_cost_center_id, presence: true
  validates :historic_id, presence: true
  validates :documento, presence: true, length: { maximum: 20 }, numericality: { only_integer: true }
  validates :data_vencimento, presence: true
  validates :valor, presence: true, numericality: { greater_than: 0 }

  #belongs_to :client
  belongs_to :client, class_name: "Client", foreign_key: "client_id", polymorphic: true
  belongs_to :cost_center
  belongs_to :sub_cost_center
  belongs_to :historic
  belongs_to :ordem_service
  belongs_to :billing
  belongs_to :sub_cost_center_three
  belongs_to :payment_method

  has_many :lower_account_receivables

  scope :received_driver, -> { where("type_account = ?", TypeAccount::MOTORISTA).order(data_vencimento: :desc) }  
  scope :last_seven_days, -> { where("created_at > ?", 7.days.ago).order(data_vencimento: :desc) }  

  before_destroy :can_destroy?
 
  module TipoStatus
    ABERTO = 0
    PAGOPARCIAL = 1
    PAGO = 2
  end

  module TypeAccount
    FORNECEDOR    = 1
    MOTORISTA     = 2
    CLIENTE       = 3
    FUNCIONARIO   = 4
    TRANSPORTADORA= 5
  end

  module TypeAccountName
    FORNECEDOR    = "Supplier"
    MOTORISTA     = "Driver"
    CLIENTE       = "Client"
    FUNCIONARIO   = "Employee"
    TRANSPORTADORA= "Carrier"
  end  

  def type_account_name
    case self.type_account
      when 1  then "Fornecedor"
      when 2  then "Motorista"
      when 3  then "Cliente"
      when 4  then "Funcionario"
      when 5  then "Transportadora"
      else "*"
    end
  end  

  def status_name
    case self.status
      when 0  then "Aberto"
      when 1  then "P. Parcial"
      when 2  then "Pago"
    else "Nao Definido"
    end
  end 

  def input_control
    InputControl.where(id: self.input_control_id).first
  end

  def total_pago
    self.lower_account_receivables.sum(:total_pago)
  end

  def saldo
    valor - self.lower_account_receivables.sum(:valor_pago)
  end

  def valor_total_pago
    lower_account_receivables.sum(:valor_pago)
  end  

  def payament(options)
    #options ||= {}
    ActiveRecord::Base.transaction do
      vr_pago = options[:valor_pago].to_f + options[:juros].to_f - options[:desconto].to_f
      options[:total_pago] = vr_pago

      vr_total_pago = valor_total_pago + options[:valor_pago].to_f

      if vr_total_pago >= self.valor
        self.status = TipoStatus::PAGO
        # if self.ordem_service_type_service.present?
        #   OrdemServiceTypeService.update(self.ordem_service_type_service, status: OrdemServiceTypeService::TipoStatus::PAGO) 
        # end
      elsif vr_total_pago < self.valor
        self.status = TipoStatus::PAGOPARCIAL
      end

      self.save

      self.lower_account_receivables.create!(data_pagamento: options[:data_pagamento],
                                          valor_pago: options[:valor_pago],
                                          juros: options[:juros],
                                          desconto: options[:desconto],
                                          total_pago: options[:total_pago],
                                          cash_account_id: options[:cash_account_id]
                                          )

      Cash.create!(cash_account_id: options[:cash_account_id], 
                              data: options[:data_pagamento],  
                              valor: vr_pago,
                               tipo: Cash::TipoLancamento::CREDITO,
                          historico: "PAGAMENTO FATURA: " + self.billing_id.to_s,
                     cost_center_id: self.cost_center_id,
                  payment_method_id: self.payment_method_id,
                 sub_cost_center_id: self.sub_cost_center_id,
           sub_cost_center_three_id: self.sub_cost_center_three_id,
              account_receivable_id: self.id
                            )

      # CurrentAccount.create!(cash_account_id: options[:cash_account_id], 
      #                       data: options[:data_pagamento],  
      #                       valor: vr_pago,
      #                       tipo: CurrentAccount::TipoLancamento::CREDITO,
      #                       historico: "BAIXA CONTA A RECEBER: " + self.documento,
      #                       account_receivable_id: self.id
      #                       )
    end
  end

  def check_balance
    self.status = self.lower_account_receivables.sum(:valor_pago).to_f > 0.0 ? 
                  TipoStatus::PAGOPARCIAL : self.status = TipoStatus::ABERTO
    self.save!
  end
  
  private

    def can_destroy?
      if self.lower_account_receivables.present?
        puts ">>>>>>>>>>>>>>>>>>>>>>>>>. não pode apagar"
        errors.add(:base, "You can not delete record with relationship") 
        return false
      end
    end


end
