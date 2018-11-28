class Billing < ActiveRecord::Base

  validates :data_vencimento, presence: true

  belongs_to :type_service, required: false
  has_many :ordem_services

  has_one :cancellation, class_name: "Cancellation", foreign_key: "cancellation_id"
  has_many :cancellations, class_name: "Cancellation", foreign_key: "cancellation_id", :as => :cancellation, dependent: :destroy
  accepts_nested_attributes_for :cancellations, allow_destroy: true, :reject_if => :all_blank

  has_many :assets, as: :asset, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank


  before_update :modify_due_date

  module TipoStatus
  	ABERTO = 0
  	PAGO = 1
    CANCELADA = 2
  end

  def status_name
    case self.status
      when 0 then "Aberto"
      when 1 then "Pago"
      when 2 then "Cancelada"
    else "Nao Definido"
    end
  end

  def feed_cancellations
    Cancellation.where("cancellation_type = ? and cancellation_id = ?", "Billing", self.id)
  end

  def to_csv
    CSV.generate do |csv|
      csv = ordem_services.column_names
      ordem_services.each do |os|
        csv << os.attributes.values_at(*self.ordem_services.column_names)
      end
    end
  end

  private

    def modify_due_date
      AccountReceivable.where(billing_id: self.id).update_all(data_vencimento: self.data_vencimento) if self.changed?
    end

end
