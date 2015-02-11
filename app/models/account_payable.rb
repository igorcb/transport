class AccountPayable < ActiveRecord::Base
  
  validates :type_account, presence: true
  validates :supplier_id, presence: true
  validates :cost_center_id, presence: true
  validates :sub_cost_center_id, presence: true
  validates :historic_id, presence: true
  validates :documento, presence: true, length: { maximum: 10 }, numericality: { only_integer: true }
  validates :data_vencimento, presence: true
  validates :valor, presence: true, numericality: { greater_than: 0 }
  validates :observacao, presence: true

  belongs_to :supplier, class_name: "Supplier", foreign_key: "supplier_id", polymorphic: true
  belongs_to :cost_center
  belongs_to :sub_cost_center
  belongs_to :historic
  belongs_to :payment_method
  belongs_to :cash_account
  belongs_to :current_account
  belongs_to :ordem_service
  belongs_to :ordem_service_type_service
  has_many :lower_account_payables

  has_many :assets, as: :asset, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank

  before_save :set_supplier_type

  module TipoStatus
    ABERTO = 0
    PAGOPARCIAL = 1
    PAGO = 2
  end

  def self.ransackable_attributes(auth_object = nil)
    ['data_vencimento', 'documento', 'supplier_id', 'supplier_type', 'type_account', 'status' ]
  end  

  def status_name
    case self.status
      when 0  then "Aberto"
      when 1  then "Pago Parcial"
      when 2  then "Pago"
    else "Nao Definido"
    end
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

  def total_pago
    self.lower_account_payables.sum(:total_pago)
  end

  def saldo
    self.valor - self.lower_account_payables.sum(:valor_pago)
  end

  def valor_total_pago
    self.lower_account_payables.sum(:valor_pago)
  end

#  def payament(data, valor, juros, desconto)
  def payament(options)
    #options ||= {}
    ActiveRecord::Base.transaction do
      vr_pago = options[:valor_pago].to_f + options[:juros].to_f - options[:desconto].to_f
      options[:total_pago] = vr_pago

      vr_total_pago = valor_total_pago + options[:valor_pago].to_f

      if vr_total_pago >= self.valor
        self.status = TipoStatus::PAGO
        if self.ordem_service_type_service.present?
          OrdemServiceTypeService.update(self.ordem_service_type_service, status: OrdemServiceTypeService::TipoStatus::PAGO) 
        end
      elsif vr_total_pago < self.valor
        self.status = TipoStatus::PAGOPARCIAL
      end

      self.lower_account_payables.create!(data_pagamento: options[:data_pagamento],
                                          valor_pago: options[:valor_pago],
                                          juros: options[:juros],
                                          desconto: options[:desconto],
                                          total_pago: options[:total_pago],
                                          cash_account_id: options[:cash_account_id]
                                          )
      self.save

      CurrentAccount.create!(cash_account_id: options[:cash_account_id], 
                            data: options[:data_pagamento],  
                            valor: vr_pago,
                            tipo: CurrentAccount::TipoLancamento::DEBITO,
                            historico: "BAIXA CONTA A PAGAR: " + self.documento,
                            account_payable_id: self.id
                            )
    end
  end

  def self.payament_all(ids, value)
    data = Time.now.strftime('%Y-%m-%d')
    valor_total = 0
    hash_ids = []
    ids.each do |i|
      hash_ids << i[0].to_i
      valor_total += i[1].to_f
      # Efetuar Faturamento
      id = i[0].to_i
      valor = i[1].to_f
      ActiveRecord::Base.transaction do
        account = AccountPayable.find(id)
        account.payament(data, account.valor, 0, 0)
      end
    end
  end

  def check_balance
    self.status = self.lower_account_payables.sum(:valor_pago).to_f > 0.0 ? 
                  TipoStatus::PAGOPARCIAL : self.status = TipoStatus::ABERTO
    self.save!
  end

  private 
    def can_destroy?
      if self.account_payables.present? ||
        errors.add(:base, "You can not delete record with relationship") 
        return false
      end
    end

  protected
  
  def set_supplier_type
    case self.type_account
      when 1 then self.supplier_type = "Supplier"
      when 2 then self.supplier_type = "Driver"
      when 3 then self.supplier_type = "Client"
      when 4 then self.supplier_type = "Employee"
      when 5 then self.supplier_type = "Carrier"
      else self.supplier_type = "Supplier"
    end
  end


end
