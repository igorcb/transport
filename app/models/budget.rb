class Budget < ActiveRecord::Base
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: :true, length: { maximum: 100 }, 
	                                   format: { with: VALID_EMAIL_REGEX },
                                 uniqueness: { case_sensitive: false }
	#validates :email, presence: true, 
  validates :nome, presence: true, length: { maximum: 100 } 
  validates :fone, presence: true, length: { maximum: 30 } 
  validates :estado_origem, presence: true
  validates :municipio_origem, presence: true, length: { maximum: 100 }
  validates :estado_destino, presence: true
  validates :municipio_destino, presence: true, length: { maximum: 100 }


  has_many :budget_items, dependent: :destroy
  accepts_nested_attributes_for :budget_items, allow_destroy: true

  before_save { |budget| budget.email = email.downcase }

  def cubagem_total
  	total = 0.00
  	self.budget_items.each do |item|
      total = total + item.cubagem_total
    end
    total
  end
end
