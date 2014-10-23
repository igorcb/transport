class Operating < ActiveRecord::Base

  validates :driver_id, presence: true
  validates :client_id, presence: true
  validates :placa, presence: true
  validates :cte, presence: true
  validates :danfe, presence: true
  validates :chave_cte, presence: true, length: { maximum: 44 }, uniqueness: true
  validates :chave_nfe, presence: true, length: { maximum: 44 }, uniqueness: true
  validates :chave_danfe_devolucao, presence: true, length: { maximum: 44 }, uniqueness: true

  belongs_to :driver
  belongs_to :client
  has_many :operating_items

  has_many :operating_items, dependent: :destroy
  accepts_nested_attributes_for :operating_items, allow_destroy: true  

  has_many :assets, as: :asset, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank  

  def fpgto_nome
    case self.fpgto
      when 0 then "A Vista"
      when 1 then "A Prazo"
    end
  end  
end
