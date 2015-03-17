class CteXml < ActiveRecord::Base
	has_attached_file :asset
	validates_attachment :asset, uniqueness: true, attachment_presence: true, :content_type => { :content_type => "text/xml" }
	validates :asset_file_name, uniqueness: true

	before_create do |cte|
		cte.status = 0
		cte.error = 0
	end 

	def status_name
		case self.status
		  when 0 then "Não Processado"
		  when 1 then "Em processamento"
		  when 2 then "Processado"
		end
  end

  def error_name
		case self.error
		  when 0 then "Sem Erros"
		  when 1 then "Contem Erros"
		end
  end
end
