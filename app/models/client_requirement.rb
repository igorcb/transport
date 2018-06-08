class ClientRequirement < ActiveRecord::Base
  validates :client_id, presence: true
  validates :client_source_id, presence: true
  validates :type_vehicle, presence: true
  validates :type_body, presence: true
  validates :type_calc, presence: true
  validates :client_source_id, uniqueness: { scope: [:client_id, :type_vehicle, :type_body], 
                                           message: ": tabela de exigencias com tipo de veiculo, tipo de carroceria já estão em uso. "}

  belongs_to :client
  belongs_to :client_source, class_name: "Client", foreign_key: :client_source_id

  module TypeFloor
    FERRO = 0
    MADEIRA = 1
    TODOS = 2
  end

  def type_vehicle_name
  	case self.type_vehicle
      when Vehicle::TipoVeiculo::CARRETA_LS then "CARRETA_LS"
      when Vehicle::TipoVeiculo::VLC then "VLC"
      when Vehicle::TipoVeiculo::TRUK then "TRUK"
      when Vehicle::TipoVeiculo::TOCO then "TOCO"
      when Vehicle::TipoVeiculo::CARRETA then "CARRETA"
      when Vehicle::TipoVeiculo::TRES_QUARTOS then "3/4"
      when Vehicle::TipoVeiculo::UTILITARIO then "UTILITARIO"
      when Vehicle::TipoVeiculo::VAN then "VAN"
      when Vehicle::TipoVeiculo::BITRUCK then "BITRUCK"
      when Vehicle::TipoVeiculo::RODOTREM then "RODOTREM"
      when Vehicle::TipoVeiculo::BITREM then "BITREM"
  	end
  end

  def type_body_name
  	case self.type_body
      when Vehicle::TipoCarroceria::BAU then "BAU"
      when Vehicle::TipoCarroceria::GRANELEIRA then "GRANELEIRA"
      when Vehicle::TipoCarroceria::BUG_PORTA_CONTAINER then "BUG_PORTA_CONTAINER"
      when Vehicle::TipoCarroceria::SIDER then "SIDER"
      when Vehicle::TipoCarroceria::BAU_FRIGORIFICO then "BAU_FRIGORIFICO"
      when Vehicle::TipoCarroceria::CACAMBA then "CACAMBA"
      when Vehicle::TipoCarroceria::GRADE_BAIXA then "GRADE_BAIXA"
      when Vehicle::TipoCarroceria::CAVAQUEIRA then "CAVAQUEIRA"
      when Vehicle::TipoCarroceria::PRANCHA then "PRANCHA"
      when Vehicle::TipoCarroceria::MUNK then "MUNK"
      when Vehicle::TipoCarroceria::SILO then "SILO"
      when Vehicle::TipoCarroceria::TANQUE then "TANQUE"
      when Vehicle::TipoCarroceria::GAIOLA then "GAIOLA"
      when Vehicle::TipoCarroceria::CEGONHEIRO then "CEGONHEIRO"
      when Vehicle::TipoCarroceria::APENAS_CAVALO then "APENAS_CAVALO"
  	end
  end

  def type_floor_name
  	case self.type_floor
  		when TypeFloor::FERRO then "Ferro"
  		when TypeFloor::MADEIRA then "Madeira"
      when TypeFloor::TODOS then "Todos"
  	end
  end  
end
