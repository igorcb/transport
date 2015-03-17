require 'spec_helper'

describe Client do
  let(:group_client) { FactoryGirl.build(:group_client) }
  before do 
    @client = FactoryGirl.build(:client)
  end

  subject { @client }
  
  it { should respond_to(:tipo_pessoa) }
  it { should respond_to(:cpf_cnpj) }
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
  it { should respond_to(:rg) }
  it { should respond_to(:orgao_emissor) }
  it { should respond_to(:data_emissao_rg) }
  it { should respond_to(:group_client) }
  it { should respond_to(:contacts) }
  it { should accept_nested_attributes_for :assets }
  it { should accept_nested_attributes_for :contacts }

  describe "when tipo pessoa is not present" do
    before { @client.tipo_pessoa = '' }
    it { should_not be_valid }
  end  

  describe "when tipo pessoa is number" do
    before { @client.tipo_pessoa = 'x' }
    it { should_not be_valid }
  end  

  describe "when tipo pessoa is number diff 0 ou 1" do
    before { @client.tipo_pessoa = 9 }
    it { should_not be_valid }
  end  

  describe "when cpf_cnpj is not present" do
    before { @client.cpf_cnpj = '' }
    it { should_not be_valid }
  end  

  describe "when fantasia is not present" do
    before { @client.fantasia = '' }
    it { should_not be_valid }
  end

  describe "when cep is not present" do
    before { @client.cep = '' }
    it { should_not be_valid }
  end

  describe "when endereco is not present" do
    before { @client.endereco = '' }
    it { should_not be_valid }
  end

  describe "when numero is not present" do
    before { @client.numero = '' }
    it { should_not be_valid }
  end

  describe "when bairro is not present" do
    before { @client.bairro = '' }
    it { should_not be_valid }
  end

  describe "when cidade is not present" do
    before { @client.cidade = '' }
    it { should_not be_valid }
  end

  describe "when estado is not present" do
    before { @client.estado = '' }
    it { should_not be_valid }
  end

  describe "with cpf_cnpj that is too long" do
    before { @client.cpf_cnpj = "a" * 19 }
    it { should_not be_valid }
  end

  describe "with nome that is too long" do
    before { @client.nome = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with fantasia that is too long" do
    before { @client.fantasia = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with cep that is too long" do
    before { @client.cep = "a" * 11 }
    it { should_not be_valid }
  end

  describe "with endereco that is too long" do
    before { @client.endereco = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with numero that is too long" do
    before { @client.numero = "a" * 16 }
    it { should_not be_valid }
  end

  describe "with complemento that is too long" do
    before { @client.complemento = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with bairro that is too long" do
    before { @client.bairro = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with cidade that is too long" do
    before { @client.cidade = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with estado that is too long" do
    before { @client.estado = "a" * 3 }
    it { should_not be_valid }
  end

  describe "with inscricao_municipal that is too long" do
    before { @client.inscricao_municipal = "a" * 21 }
    it { should_not be_valid }
  end

  describe "with inscricao_estadual that is too long" do
    before { @client.inscricao_estadual = "a" * 21 }
    it { should_not be_valid }
  end

  describe "when cpf_cnpj is already taken" do
	  before do 
      @client = Client.create(tipo_pessoa: Client::TipoPessoa::FISICA,
                               cpf_cnpj: '00000000000000', 
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
