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
  #enum active: [true, disabled: false}
end
