require 'spec_helper'

describe Cash do
  let(:payment_method) { FactoryGirl.create(:payment_method) }
  before do 
		@cash = Cash.create(data: Time.now.strftime('%Y-%m-%d'), 
												valor: 0.10, 
												tipo: Cash::TipoLancamento::DEBITO,
												payment_method_id: payment_method.id
												)
  end
  
  subject { @cash } 
  
  it { should respond_to(:data) }
  it { should respond_to(:valor) }
  it { should respond_to(:tipo) }
  it { should respond_to(:historic_id) }
  it { should respond_to(:payment_method_id) }
  it { should respond_to(:cost_center_id) }
  it { should respond_to(:sub_cost_center_id) }
  it { should respond_to(:credito_debito) }

  describe "when data cash is not present" do
    before { @cash.data = '' }
    it { should_not be_valid }
  end    

  describe "when tipo cash is not present" do
    before { @cash.tipo = '' }
    it { should_not be_valid }
  end    

  describe "when valor cash is not present" do
    before { @cash.valor = '' }
    it { should_not be_valid }
  end    

  describe "when historic_id cash is not present" do
    before { @cash.historic_id = '' }
    it { should_not be_valid }
  end    

  describe "when payment_method_id cash is not present" do
    before { @cash.payment_method_id = '' }
    it { should_not be_valid }
  end    

  describe "when cost_center_id cash is not present" do
    before { @cash.cost_center_id = '' }
    it { should_not be_valid }
  end    

  describe "when sub_cost_center_id cash is not present" do
    before { @cash.sub_cost_center_id = '' }
    it { should_not be_valid }
  end    
end
