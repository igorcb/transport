# require 'spec_helper'
require 'rails_helper'

#describe OrdemService do
RSpec.describe OrdemService, type: :model do
	# let(:driver) { FactoryGirl.build(:driver) }
	# let(:client) { FactoryGirl.build(:client) }
	# let(:source_client) { FactoryGirl.build(:client) }
	let(:ordem_service) { FactoryBot.create(:ordem_service) }

  before(:each) do

    # @ordem_service = FactoryBot.create(:ordem_service)

  end
	it 'is valid if all fields have value' do
    expect { ordem_service }.to change { OrdemService.count }.by(1)
  end

	it "when place is not present" do
		ordem_service.placa = nil
		expect(ordem_service.placa).to be_falsey
	end

	it "when place is present" do
		ordem_service.placa = 'HHH-0000'
		expect(ordem_service.placa).to be_truthy
	end

	# subject { @ordem_service }
	#
	# it { should respond_to(:driver_id) }
	# it { should respond_to(:target_client_id) }
	# it { should respond_to(:source_client_id) }
	it { should respond_to(:data) }
	it { should respond_to(:placa) }
	it { should respond_to(:estado) }
	it { should respond_to(:cidade) }
	it { should respond_to(:cte) }
	it { should respond_to(:danfe_cte) }
	it { should respond_to(:valor_receita) }
	it { should respond_to(:valor_despesas) }
	it { should respond_to(:valor_liquido) }
	it { should respond_to(:status) }
	it { should respond_to(:qtde_volume) }
	it { should respond_to(:peso) }
	it { should respond_to(:billing_id) }
	it { should respond_to(:data_entrega_servico) }
	it { should respond_to(:senha_sefaz) }
	it { should respond_to(:tipo) }
	it { should respond_to(:data_solicitacao) }
	#
  # #Methods
	# it { should respond_to(:valor_ordem_service) }
	# it { should respond_to(:valor_os) }
	# it { should respond_to(:valor_peso) }
	# it { should respond_to(:valor_1500) }
	# it { should respond_to(:qtde) }
	#
	# #Associations
	# it { should respond_to(:client) }
	# it { should respond_to(:source_client) }
	# it { should respond_to(:billing_client) }
	# it { should respond_to(:driver) }
	#
	# it { should respond_to(:nfe_keys) }
	# it { should respond_to(:ordem_service_type_service) }
	# it { should respond_to(:assets) }
	# it { should respond_to(:ordem_service_logistic) }
	# it { should respond_to(:ordem_service_logistics) }
	# it { should respond_to(:ordem_service_air) }
	# it { should respond_to(:ordem_service_airs) }
	# it { should accept_nested_attributes_for :ordem_service_logistics }
	# it { should accept_nested_attributes_for :ordem_service_airs }
	# it { should accept_nested_attributes_for :nfe_keys }
	# it { should accept_nested_attributes_for :ordem_service_type_service }
	# it { should accept_nested_attributes_for :assets }

  # describe "when driver is not present" do
  #   before { @ordem_service.driver_id = '' }
  #   it { should_not be_valid }
  # end

  # describe "when client is not present" do
  #   before { @ordem_service.client_id = '' }
  #   it { should_not be_valid }
  # end

  # describe "when placa is not present" do
  #   before { @ordem_service.placa = '' }
  #   it { should_not be_valid }
  # end

  # describe "when estado is not present" do
  #   before { @ordem_service.estado = '' }
  #   it { should_not be_valid }
  # end

  # describe "when cidade is not present" do
  #   before { @ordem_service.cidade = '' }
  #   it { should_not be_valid }
  # end

  # describe "when cte is not present" do
  #   before { @ordem_service.cte = '' }
  #   it { should_not be_valid }
  # end

  # describe "with cte that is too long" do
  #   before { @ordem_service.cte = "a" * 21 }
  #   it { should_not be_valid }
  # end

  # describe "with cte that is not number" do
  #   before { @ordem_service.cte = "XXXXXX" }
  #   it { should_not be_valid }
  # end

end
