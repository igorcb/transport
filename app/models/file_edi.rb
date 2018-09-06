class FileEdi < ActiveRecord::Base
	validates :type_file, presence: true
	validates :date_file, presence: true
	validates :name_file, presence: true
	validates :content, presence: true
  validates :shipper_id, presence: true
	#validates :date_boarding, presence: true

	belongs_to :shipper
	belongs_to :carrier

	has_many :notfis

	module TypeFile
		EDI_OCCURRENCE = "EDI_OCCURRENCE"
		EDI_NOTFIS = "EDI_NOTFIS"
	end

	def type_file_name
		case self.type_file
			when 0 then "EDI_OCCURRENCE"
			when 1 then "EDI_NOTFIS"
		end
	end

  # def self.ransackable_attributes(auth_object = nil)
  #   ['place', 'date_boarding', 'shipper_id']
  # end
end
