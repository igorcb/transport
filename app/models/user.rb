class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :employee
	has_many :notifications, foreign_key: :recipient_id         

	def active_name
		case self.active
			when 0 then "Não"
			when 1 then "Sim"
			else ""
	  end
	end
end


