require 'spec_helper'

describe Driver do
	#let(:address) { FactoryGirl.create(:address) }
  before do 
  	@driver = Driver.create(        cpf: '00000000000', 
                                   nome: 'IGOR C BATISTA', 
                               fantasia: 'IGOR', 
                                    cep: '60742300',
                               endereco: 'Rua Libania',
                                 numero: '105',
                            complemento: nil,
                                 bairro: 'Serrinha',
                                 cidade: 'Fortaleza',
                                 estado: 'CE',
                                     rg: '92002099618',
                                    cnh: '00525878207',
                              categoria: Driver::Categoria::B,
                           validade_cnh: '2014-09-09',
                           data_emissao: '2011-02-02',
                                ) 

  end

  subject { @driver }
  
  it { should respond_to(:cpf) }
  it { should respond_to(:nome) }
  it { should respond_to(:fantasia) }
  it { should respond_to(:cep) }
  it { should respond_to(:endereco) }
  it { should respond_to(:numero) }
  it { should respond_to(:complemento) }
  it { should respond_to(:bairro) }
  it { should respond_to(:cidade) }
  it { should respond_to(:estado) }
  it { should respond_to(:rg) }
  it { should respond_to(:cnh) }
  it { should respond_to(:categoria) }
  it { should respond_to(:validade_cnh) }
  it { should respond_to(:data_emissao) }

  describe "when cpf is not present" do
    before { @driver.cpf = '' }
    it { should_not be_valid }
  end  

  describe "when fantasia is not present" do
    before { @driver.fantasia = '' }
    it { should_not be_valid }
  end

  describe "when cep is not present" do
    before { @driver.cep = '' }
    it { should_not be_valid }
  end

  describe "when endereco is not present" do
    before { @driver.endereco = '' }
    it { should_not be_valid }
  end

  describe "when numero is not present" do
    before { @driver.numero = '' }
    it { should_not be_valid }
  end

  describe "when bairro is not present" do
    before { @driver.bairro = '' }
    it { should_not be_valid }
  end

  describe "when cidade is not present" do
    before { @driver.cidade = '' }
    it { should_not be_valid }
  end

  describe "when estado is not present" do
    before { @driver.estado = '' }
    it { should_not be_valid }
  end

  describe "when rg is not present" do
    before { @driver.rg = '' }
    it { should_not be_valid }
  end

  describe "when cnh is not present" do
    before { @driver.cnh = '' }
    it { should_not be_valid }
  end

  describe "when categoria is not present" do
    before { @driver.categoria = '' }
    it { should_not be_valid }
  end

  describe "when validade_cnh is not present" do
    before { @driver.validade_cnh = '' }
    it { should_not be_valid }
  end

  describe "when data_emissao is not present" do
    before { @driver.data_emissao = '' }
    it { should_not be_valid }
  end

  describe "with cpf that is too long" do
    before { @driver.cpf = "a" * 15 }
    it { should_not be_valid }
  end

  describe "with nome that is too long" do
    before { @driver.nome = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with fantasia that is too long" do
    before { @driver.fantasia = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with cep that is too long" do
    before { @driver.cep = "a" * 11 }
    it { should_not be_valid }
  end

  describe "with endereco that is too long" do
    before { @driver.endereco = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with numero that is too long" do
    before { @driver.numero = "a" * 16 }
    it { should_not be_valid }
  end

  describe "with complemento that is too long" do
    before { @driver.complemento = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with bairro that is too long" do
    before { @driver.bairro = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with cidade that is too long" do
    before { @driver.cidade = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with estado that is too long" do
    before { @driver.estado = "a" * 3 }
    it { should_not be_valid }
  end

  describe "with rg that is too long" do
    before { @driver.rg = "a" * 21 }
    it { should_not be_valid }
  end

  describe "with rg that is too long" do
    before { @driver.rg = "a" * 21 }
    it { should_not be_valid }
  end

  describe "when categoria is number" do
    before { @driver.categoria = 'x' }
    it { should_not be_valid }
  end  

  describe "when tipo pessoa is number" do
    before { @driver.categoria = 9 }
    it { should_not be_valid }
  end  


  describe "when cpf is already taken" do
	  before do 
      @driver = Driver.create(cpf: '00000000000', 
                                   nome: 'IGOR C BATISTA', 
                               fantasia: 'IGOR', 
                                    cep: '60742300',
                               endereco: 'Rua Libania',
                                 numero: '105',
                            complemento: nil,
                                 bairro: 'Serrinha',
                                 cidade: 'Fortaleza',
                                 estado: 'CE',
                                     rg: '92002099618',
                                    cnh: '00525878207',
                              categoria: Driver::Categoria::B,
                           validade_cnh: '2014-09-09',
                           data_emissao: '2011-02-02',
                                ) 	  
    end
    
    it { should_not be_valid }
  end  
end
