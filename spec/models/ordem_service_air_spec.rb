require 'spec_helper'

describe OrdemServiceAir do
	let(:stretch_source) { FactoryGirl.build(:stretch_source) }
	let(:stretch_target) { FactoryGirl.build(:stretch_target) }
	let(:agent_target) { FactoryGirl.build(:agent_target) }
	let(:airline) { FactoryGirl.build(:airline) }
	let(:ordem_service) { FactoryGirl.build(:ordem_service_air) }
  before do 
  	@air = ordem_service.ordem_service_airs.build(
  						source_stretch_id: stretch_source.id,
  						target_stretch_id: stretch_target.id,
  						target_agent_id: agent_target.id,
  						airline_carrier_id: airline.id,
  						solicitante: "FULANO",
  						awb: "123456789",
  						voo: "1223",
  						tipo_frete: 0,
  						qtde_volume: 10,
  						peso: 320.471,
  						valor_nf: 0,
  						total_cubagem: 300.921,
  						tarifa_companhia: 4.00,
  						valor_total: 1000.00
  		 )

  end

  subject { @air } 
  
  it { should respond_to(:source_stretch_id) }
  it { should respond_to(:target_stretch_id) }
  it { should respond_to(:target_agent_id) }
  it { should respond_to(:airline_carrier_id) }
  it { should respond_to(:solicitante) }
  it { should respond_to(:awb) }
  it { should respond_to(:voo) }
  it { should respond_to(:tipo_frete) }
  it { should respond_to(:qtde_volume) }
  it { should respond_to(:qtde_volume) }
  it { should respond_to(:peso) }
  it { should respond_to(:valor_nf) }
  it { should respond_to(:total_cubagem) }
  it { should respond_to(:valor_total) }
  it { should respond_to(:ordem_service) }
  it { should respond_to(:stretch_source) }
  it { should respond_to(:stretch_target) }
  it { should respond_to(:airline) }
  it { should respond_to(:agent_target) }

  it { should respond_to(:stretch) }
end

