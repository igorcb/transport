class Cancellation < ActiveRecord::Base
  validates :solicitation_user_id, presence: true
  validates :authorization_user_id, presence: true
  validates :observacao, presence: true, length: { minimum: 15 }
  belongs_to :solicitation_user, class_name: "User", foreign_key: 'solicitation_user_id'
  belongs_to :authorization_user, class_name: "User", foreign_key: 'authorization_user_id'
  
  belongs_to :ordem_service, class_name: "OrdemService", foreign_key: "cancel_id", polymorphic: true, dependent: :destroy
end
