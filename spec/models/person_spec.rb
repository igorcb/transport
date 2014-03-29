require 'spec_helper'

describe Person do
	let(:address) { FactoryGirl.create(:address) }
  before do 
  	@person = Person.create(cpf_cnpj: '00000000000000', 
  	                                   nome: 'IGOR C B - ME', 
  	                               fantasia: 'I4 TECNOLOGIA', 
  	                             address_id: address.id, 
  	                                 numero: '102', 
  	                            complemento: 'prox a pague menos') 
  end

  subject { @person }

  it { should respond_to(:cpf_cnpj) }
  it { should respond_to(:nome) }
  it { should respond_to(:fantasia) }
  it { should respond_to(:numero) }
  it { should respond_to(:complemento) }
  it { should respond_to(:address_id) }
  it { should respond_to(:address) }

  describe "when address_id is not present" do
    before { @person.address_id = nil }
    it { should_not be_valid }
  end  

  describe "when cpf_cnpj is not present" do
    before { @person.cpf_cnpj = '' }
    it { should_not be_valid }
  end  

  describe "when fantasia is not present" do
    before { @person.fantasia = '' }
    it { should_not be_valid }
  end

  describe "when numero is not present" do
    before { @person.numero = '' }
    it { should_not be_valid }
  end

  describe "with cpf_cnpj that is too long" do
    before { @person.cpf_cnpj = "a" * 19 }
    it { should_not be_valid }
  end

  describe "with nome that is too long" do
    before { @person.nome = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with fantasia that is too long" do
    before { @person.fantasia = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with numero that is too long" do
    before { @person.numero = "a" * 16 }
    it { should_not be_valid }
  end

  describe "with complemento that is too long" do
    before { @person.complemento = "a" * 101 }
    it { should_not be_valid }
  end

  describe "when cpf_cnpj is already taken" do
	  before do 
	  	@person = Person.create(cpf_cnpj: '00000000000000', 
	  	                                   nome: 'IGOR C B - ME', 
	  	                               fantasia: 'I4 TECNOLOGIA', 
	  	                             address_id: address.id, 
	  	                                 numero: '102', 
	  	                            complemento: 'prox a pague menos') 
	  end
    
    it { should_not be_valid }
  end  


end
