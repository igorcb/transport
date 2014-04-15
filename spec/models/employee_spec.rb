require 'spec_helper'

describe Employee do
	#let(:address) { FactoryGirl.create(:address) }
  before do 
  	@employee = Employee.create(    cpf: '00000000000', 
                                   nome: 'IGOR C B - ME', 
                                apelido: 'IGOR', 
                                    cep: '60742300',
                               endereco: 'Rua Libania',
                                 numero: '105',
                            complemento: nil,
                                 bairro: 'Serrinha',
                                 cidade: 'Fortaleza',
                                 estado: 'CE',
                                   tipo: Employee::TipoEmployee::FIXO
                         #        carrega: true,
                         #         embala: true,
                         #       desmonta: false,
                         #       icamento: false,  
                         #         arruma: false,
                         #    iventarista: false,
                         # confere_carga: false
                                 ) 

  end

  subject { @employee }
  
  it { should respond_to(:cpf) }
  it { should respond_to(:nome) }
  it { should respond_to(:apelido) }
  it { should respond_to(:cep) }
  it { should respond_to(:endereco) }
  it { should respond_to(:numero) }
  it { should respond_to(:complemento) }
  it { should respond_to(:bairro) }
  it { should respond_to(:cidade) }
  it { should respond_to(:estado) }
  it { should respond_to(:tipo) }
  # it { should respond_to(:carrega) }
  # it { should respond_to(:embala) }
  # it { should respond_to(:desmonta) }
  # it { should respond_to(:icamento) }
  # it { should respond_to(:arruma) }
  # it { should respond_to(:iventarista) }
  # it { should respond_to(:confere_carga) }

  describe "when tipo is not present" do
    before { @employee.tipo = '' }
    it { should_not be_valid }
  end  

  describe "when tipo is number" do
    before { @employee.tipo = 'x' }
    it { should_not be_valid }
  end  

  describe "when tipo is number diff 0 ou 1" do
    before { @employee.tipo = 9 }
    it { should_not be_valid }
  end  

  describe "when cpf is not present" do
    before { @employee.cpf = '' }
    it { should_not be_valid }
  end  

  describe "when apelido is not present" do
    before { @employee.apelido = '' }
    it { should_not be_valid }
  end

  describe "when cep is not present" do
    before { @employee.cep = '' }
    it { should_not be_valid }
  end

  describe "when endereco is not present" do
    before { @employee.endereco = '' }
    it { should_not be_valid }
  end

  describe "when numero is not present" do
    before { @employee.numero = '' }
    it { should_not be_valid }
  end

  describe "when bairro is not present" do
    before { @employee.bairro = '' }
    it { should_not be_valid }
  end

  describe "when cidade is not present" do
    before { @employee.cidade = '' }
    it { should_not be_valid }
  end

  describe "when estado is not present" do
    before { @employee.estado = '' }
    it { should_not be_valid }
  end

  describe "with cpf that is too long" do
    before { @employee.cpf = "a" * 15 }
    it { should_not be_valid }
  end

  describe "with nome that is too long" do
    before { @employee.nome = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with apelido that is too long" do
    before { @employee.apelido = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with cep that is too long" do
    before { @employee.cep = "a" * 11 }
    it { should_not be_valid }
  end

  describe "with endereco that is too long" do
    before { @employee.endereco = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with numero that is too long" do
    before { @employee.numero = "a" * 16 }
    it { should_not be_valid }
  end

  describe "with complemento that is too long" do
    before { @employee.complemento = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with bairro that is too long" do
    before { @employee.bairro = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with cidade that is too long" do
    before { @employee.cidade = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with estado that is too long" do
    before { @employee.estado = "a" * 3 }
    it { should_not be_valid }
  end

  describe "when cpf is already taken" do
	  before do 
      @employee = Employee.create(  cpf: '00000000000', 
                                   nome: 'IGOR C B - ME', 
                                apelido: 'I4 TECNOLOGIA', 
                                    cep: '60742300',
                               endereco: 'Rua Libania',
                                 numero: '105',
                            complemento: nil,
                                 bairro: 'Serrinha',
                                 cidade: 'Fortaleza',
                                 estado: 'CE',
                                   tipo: Employee::TipoEmployee::FIXO
                                 ) 
	  end
    
     it { should_not be_valid }
  end  

end
