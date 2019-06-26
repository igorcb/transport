class FileEdi < ActiveRecord::Base
	validates :type_file, presence: true
	validates :date_file, presence: true
	validates :name_file, presence: true
	validates :content, presence: true
  validates :shipper_id, presence: true
	#validates :date_boarding, presence: true

	belongs_to :shipper, required: false
	belongs_to :carrier, required: false

	has_many :notfis

	has_many :nfe_xmls, through: :notfis

  before_create do |item|
		item.place = item.place.upcase if item.place.present?
  end

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

	def get_nfe_xmls
		self.nfe_xmls.select(:numero).pluck(:numero).uniq
	end

  # def self.ransackable_attributes(auth_object = nil)
  #   ['place', 'date_boarding', 'shipper_id']
  # end
end
