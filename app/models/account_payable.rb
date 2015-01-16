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
    ['data_vencimento', 'documento', 'supplier_id' ]
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
      when 0  then "Fornecedor"
      when 1  then "Motorista"
      when 2  then "Cliente"
      when 3  then "Funcionario"
      when 4  then "Transportadora"
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
      puts ">>>>>>>>>>>>>>>>>>> total: #{vr_pago}"
      puts ">>>>>>>> valor_total_pago: #{valor_total_pago}"
      vr_total_pago = valor_total_pago + options[:valor_pago].to_f
      #if valor_total_pago >= self.valor
      if vr_total_pago >= self.valor
        self.status = TipoStatus::PAGO
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
      when 0 then self.supplier_type = "Supplier"
      when 1 then self.supplier_type = "Driver"
      when 2 then self.supplier_type = "Client"
      when 3 then self.supplier_type = "Employee"
      when 4 then self.supplier_type = "Carrier"
    end
  end


end
