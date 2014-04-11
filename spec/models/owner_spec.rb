require 'spec_helper'

describe Owner do
  before do 
		@owner = Owner.create(     cpf_cnpj: '00000000000000', 
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
                               estado: 'CE',
  												         rg: '200209200618',
  									    orgao_emissor: 'SSP/CE',
      								data_emissao_rg: '2002/09/02'
                               ) 
  end

  subject { @owner }

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

  describe "when cpf_cnpj is not present" do
    before { @owner.cpf_cnpj = '' }
    it { should_not be_valid }
  end  

  describe "when nome is not present" do
    before { @owner.nome = '' }
    it { should_not be_valid }
  end  

  describe "when fantasia is not present" do
    before { @owner.fantasia = '' }
    it { should_not be_valid }
  end

  describe "when cep is not present" do
    before { @owner.cep = '' }
    it { should_not be_valid }
  end

  describe "when endereco is not present" do
    before { @owner.endereco = '' }
    it { should_not be_valid }
  end

  describe "when numero is not present" do
    before { @owner.numero = '' }
    it { should_not be_valid }
  end

  describe "when bairro is not present" do
    before { @owner.bairro = '' }
    it { should_not be_valid }
  end

  describe "when cidade is not present" do
    before { @owner.cidade = '' }
    it { should_not be_valid }
  end

  describe "when estado is not present" do
    before { @owner.estado = '' }
    it { should_not be_valid }
  end

  describe "with cpf_cnpj that is too long" do
    before { @owner.cpf_cnpj = "a" * 19 }
    it { should_not be_valid }
  end

  describe "with nome that is too long" do
    before { @owner.nome = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with fantasia that is too long" do
    before { @owner.fantasia = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with endereco that is too long" do
    before { @owner.endereco = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with cep that is too long" do
    before { @owner.cep = "a" * 11 }
    it { should_not be_valid }
  end

  describe "with endereco that is too long" do
    before { @owner.endereco = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with numero that is too long" do
    before { @owner.numero = "a" * 16 }
    it { should_not be_valid }
  end

  describe "with complemento that is too long" do
    before { @owner.complemento = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with bairro that is too long" do
    before { @owner.bairro = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with cidade that is too long" do
    before { @owner.cidade = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with estado that is too long" do
    before { @owner.estado = "a" * 3 }
    it { should_not be_valid }
  end

  describe "with inscricao_municipal that is too long" do
    before { @owner.inscricao_municipal = "a" * 21 }
    it { should_not be_valid }
  end

  describe "with inscricao_estadual that is too long" do
    before { @owner.inscricao_estadual = "a" * 21 }
    it { should_not be_valid }
  end

  describe "with rg that is too long" do
    before { @owner.rg = "a" * 21 }
    it { should_not be_valid }
  end

  describe "with orgao_emissor that is too long" do
    before { @owner.orgao_emissor = "a" * 21 }
    it { should_not be_valid }
  end

end
