class FileEdi < ActiveRecord::Base
	validates :type_file, presence: true
	validates :date_file, presence: true
	validates :name_file, presence: true
	validates :content, presence: true

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
end
