class Sector < ActiveRecord::Base

	validates :name, uniqueness: true
	
	scope :type_sector, -> { where(id: TypeSector::ADMINISTRATIVO) }

	module TypeSector
		ADMINISTRATIVO = 1
		COMERCIAL = 2
		FINANCEIRO = 3
		REPRESENTANTE = 4 
		OPERACIONAL = 5
		PALLETS = 6
		LOGISTICA_REVERSA = 7
		REGISTROS_OCORRENCIA = 8
		CONFIRMACAO_ENTREGA = 9
  end

end
