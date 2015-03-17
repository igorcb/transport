class GroupClient < ActiveRecord::Base
	validates :descricao, presence: true, uniqueness: true

	has_many :clients
end
