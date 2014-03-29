require 'spec_helper'

describe Carrier do
	#let(:address) { FactoryGirl.create(:address) }
  before do 
  	@carrier = Carrier.create(cnpj: '00000000000000', 
                    inscricao_municipal: nil,
                     inscricao_estadual: nil,
                                   nome: 'IGOR C B - ME', 
                               fantasia: 'I4 TECNOLOGIA', 
                                    cep: '60742300',
                               endereco: 'Rua Libania',
                                 numero: '105',
                            complemento: nil,
                                 bairro: 'Serrinha',
                                 cidade: 'Fortaleza',
                                 estado: 'CE'
                                 ) 

  end

  subject { @carrier }
  
  it { should respond_to(:cnpj) }
  it { should respond_to(:inscricao_municipal) }
  it { should respond_to(:inscricao_estadual) }
  it { should respond_to(:nome) }
  it { should respond_to(:fantasia) }
  it { should respond_to(:cep) }
  it { should respond_to(:endereco) }
  it { should respond_to(:numero) }
  it { should respond_to(:complemento) }
  it { should respond_to(:bairro) }
  it { should respond_to(:cidade) }
  it { should respond_to(:estado) }

  describe "when cnpj is not present" do
    before { @carrier.cnpj = '' }
    it { should_not be_valid }
  end  

  describe "when fantasia is not present" do
    before { @carrier.fantasia = '' }
    it { should_not be_valid }
  end

  describe "when cep is not present" do
    before { @carrier.cep = '' }
    it { should_not be_valid }
  end

  describe "when endereco is not present" do
    before { @carrier.endereco = '' }
    it { should_not be_valid }
  end

  describe "when numero is not present" do
    before { @carrier.numero = '' }
    it { should_not be_valid }
  end

  describe "when bairro is not present" do
    before { @carrier.bairro = '' }
    it { should_not be_valid }
  end

  describe "when cidade is not present" do
    before { @carrier.cidade = '' }
    it { should_not be_valid }
  end

  describe "when estado is not present" do
    before { @carrier.estado = '' }
    it { should_not be_valid }
  end

  describe "with cnpj that is too long" do
    before { @carrier.cnpj = "a" * 19 }
    it { should_not be_valid }
  end

  describe "with nome that is too long" do
    before { @carrier.nome = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with fantasia that is too long" do
    before { @carrier.fantasia = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with cep that is too long" do
    before { @carrier.cep = "a" * 11 }
    it { should_not be_valid }
  end

  describe "with endereco that is too long" do
    before { @carrier.endereco = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with numero that is too long" do
    before { @carrier.numero = "a" * 16 }
    it { should_not be_valid }
  end

  describe "with complemento that is too long" do
    before { @carrier.complemento = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with bairro that is too long" do
    before { @carrier.bairro = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with cidade that is too long" do
    before { @carrier.cidade = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with estado that is too long" do
    before { @carrier.estado = "a" * 3 }
    it { should_not be_valid }
  end

  describe "with inscricao_municipal that is too long" do
    before { @carrier.inscricao_municipal = "a" * 21 }
    it { should_not be_valid }
  end

  describe "with inscricao_estadual that is too long" do
    before { @carrier.inscricao_estadual = "a" * 21 }
    it { should_not be_valid }
  end

  describe "when cpf_cnpj is already taken" do
	  before do 
    	@carrier = Carrier.create(cnpj: '00000000000000', 
                    inscricao_municipal: nil,
                     inscricao_estadual: nil,
                                   nome: 'IGOR C B - ME', 
                               fantasia: 'I4 TECNOLOGIA', 
                                    cep: '60742300',
                               endereco: 'Rua Libania',
                                 numero: '105',
                            complemento: nil,
                                 bairro: 'Serrinha',
                                 cidade: 'Fortaleza',
                                 estado: 'CE'
                                 ) 
	  end
    
     it { should_not be_valid }
  end  
end
