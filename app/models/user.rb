class User < ActiveRecord::Base
  rolify
  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :employee, required: false
	has_many :notifications, foreign_key: :recipient_id
  has_many :links

  has_attached_file :avatar, styles: lambda { |a| a.instance.avatar_content_type =~ %r(image) ? { mini: "144x90>"} : {} }
  do_not_validate_attachment_file_type :avatar

	def active_name
		case self.active
			when 0 then "Não"
			when 1 then "Sim"
			else ""
	  end
	end

  def active_for_authentication?
    case self.active
      when 0 then result = false
      when 1 then result = true
			else ""
	  end
    result
  end

  def inactive_message
    "Sorry, this account has been deactivated."
  end
end
