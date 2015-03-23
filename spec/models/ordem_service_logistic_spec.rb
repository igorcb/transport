require 'spec_helper'

describe OrdemServiceLogistic do
	let(:driver) { FactoryGirl.build(:driver) }
	let(:driver_delivery) { FactoryGirl.build(:driver) }
	let(:ordem_service) { FactoryGirl.build(:ordem_service) }
  before do 
  	@logistic = ordem_service.ordem_service_logistics.build(
  							driver_id: driver.id,
  							delivery_driver_id: driver_delivery.id,
  							placa: "AUH-3298",
                qtde_volume: 10,
                peso: 100
  							#cte: "098765",
  							#danfe_cte: "0987650987650987650987651234"

  		)

  end

  subject { @logistic } 
  
  it { should respond_to(:driver_id) }
  it { should respond_to(:delivery_driver_id) }
  it { should respond_to(:placa) }
  it { should respond_to(:qtde_volume) }
  it { should respond_to(:peso) }
  # it { should respond_to(:cte) }
  # it { should respond_to(:danfe_cte) }
  it { should respond_to(:ordem_service) }
end
