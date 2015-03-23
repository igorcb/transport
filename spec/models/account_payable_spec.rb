require 'spec_helper'

describe AccountPayable do
  let(:supplier) { FactoryGirl.build(:supplier) }
	let(:cost_center) { FactoryGirl.build(:cost_center) }
	let(:sub_cost_center) { FactoryGirl.build(:sub_cost_center) }
	let(:historic) { FactoryGirl.build(:historic) }
	#let(:ordem_service) { FactoryGirl.build(:ordem_service) }
  before do 
  	@account = AccountPayable.create(
  						supplier_id: supplier.id,
  						cost_center_id: cost_center.id,
  						sub_cost_center_id: sub_cost_center.id,
  						historic_id: historic.id,
  						documento: '9999' ,
  						data_vencimento: Time.now.strftime('%Y-%m-%d'),
  						valor: 1000.00,
  						observacao: "Nunc eu feugiat lorem"
  		 )

  end

  subject { @account } 
  
  it { should respond_to(:supplier_id) }
  it { should respond_to(:cost_center_id) }
  it { should respond_to(:sub_cost_center_id) }
  it { should respond_to(:historic_id) }
  it { should respond_to(:documento) }
  it { should respond_to(:data_vencimento) }
  it { should respond_to(:valor) }
  it { should respond_to(:observacao) }
  it { should respond_to(:status) }

	#Associations
	it { should respond_to(:supplier) }
	it { should respond_to(:cost_center) }
	it { should respond_to(:sub_cost_center) }
	it { should respond_to(:historic) }

  describe "when supplier_id is not present" do
    before { @account.supplier_id = '' }
    it { should_not be_valid }
  end  

  describe "when cost_center is not present" do
    before { @account.cost_center_id = '' }
    it { should_not be_valid }
  end  

  describe "when sub_cost_center is not present" do
    before { @account.sub_cost_center_id = '' }
    it { should_not be_valid }
  end  

  describe "when historic is not present" do
    before { @account.historic_id = '' }
    it { should_not be_valid }
  end  

  describe "when documento is not present" do
    before { @account.documento = '' }
    it { should_not be_valid }
  end  

  describe "when data_vencimento is not present" do
    before { @account.data_vencimento = '' }
    it { should_not be_valid }
  end  
end
