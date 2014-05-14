class PhoneCall < ActiveRecord::Base
  belongs_to :type_service

  validates :nome, presence: true, length: { maximum: 100 } 
  validates :telefone, presence: true, length: { maximum: 50 } 
  validates :email, length: { maximum: 100 } 
  validates :type_service_id, presence: true, length: { maximum: 10 } 
  validates :assunto, presence: true

end