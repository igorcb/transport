require 'spec_helper'

describe Vehicle do
  before do 
  	@vehicle = Vehicle.create(marca: "Mercedes",
  		                       modelo: "BAU",
  		                          ano: 1900,
  		                          cor: "BRANCA",
  		                 tipo_veiculo: Vehicle::TipoVeiculo::STANDARD,
  		       municipio_emplacamento: "Forteleza",
  		                       estado: "CE",
  		                      renavan: "00009987",
  		                       chassi: "9BGRD08X04G117974",
  		                   capacidade: "10",
  		                        placa: "HXQ3666"
  		                      	)
  end

  subject { @vehicle }

  it { should respond_to(:marca) }
  it { should respond_to(:modelo) }
  it { should respond_to(:ano) }
  it { should respond_to(:tipo_veiculo) }
  it { should respond_to(:municipio_emplacamento) }
  it { should respond_to(:estado) }
  it { should respond_to(:renavan) }
  it { should respond_to(:chassi) }
  it { should respond_to(:capacidade) }
  it { should respond_to(:placa) }

  describe "when marca is not present" do
    before { @vehicle.marca = '' }
    it { should_not be_valid }
  end  

  describe "when modelo is not present" do
    before { @vehicle.modelo = '' }
    it { should_not be_valid }
  end  

  describe "when ano is not present" do
    before { @vehicle.ano = '' }
    it { should_not be_valid }
  end  

  describe "when tipo_veiculo is not present" do
    before { @vehicle.tipo_veiculo = '' }
    it { should_not be_valid }
  end  

  describe "when municipio_emplacamento is not present" do
    before { @vehicle.municipio_emplacamento = '' }
    it { should_not be_valid }
  end  

  describe "when estado is not present" do
    before { @vehicle.estado = '' }
    it { should_not be_valid }
  end  

  describe "when renavan is not present" do
    before { @vehicle.renavan = '' }
    it { should_not be_valid }
  end  

  describe "when chassi is not present" do
    before { @vehicle.chassi = '' }
    it { should_not be_valid }
  end  

  describe "when capacidade is not present" do
    before { @vehicle.capacidade = '' }
    it { should_not be_valid }
  end  

  describe "when placa is not present" do
    before { @vehicle.placa = '' }
    it { should_not be_valid }
  end  

  describe "with marca that is too long" do
    before { @vehicle.marca = "a" * 22 }
    it { should_not be_valid }
  end

  describe "with modelo that is too long" do
    before { @vehicle.modelo = "a" * 22 }
    it { should_not be_valid }
  end
  # validacao do ano x a ano ny
  # validaccao somente numero
  describe "with ano that is too long" do
    before { @vehicle.ano = "a" * 5 }
    it { should_not be_valid }
  end

  describe "with cor that is too long" do
    before { @vehicle.cor = "a" * 22 }
    it { should_not be_valid }
  end

  describe "with tipo_veiculo that is too long" do
    before { @vehicle.tipo_veiculo = "a" * 22 }
    it { should_not be_valid }
  end

  describe "with municipio_emplacamento that is too long" do
    before { @vehicle.municipio_emplacamento = "a" * 101 }
    it { should_not be_valid }
  end

  describe "with estado that is too long" do
    before { @vehicle.estado = "a" * 3 }
    it { should_not be_valid }
  end

  describe "with renavan that is too long" do
    before { @vehicle.renavan = "a" * 22 }
    it { should_not be_valid }
  end

  describe "with chassi that is too long" do
    before { @vehicle.chassi = "a" * 22 }
    it { should_not be_valid }
  end

  # describe "with capacidade that is too long" do
  #   before { @vehicle.capacidade = "a" * 22 }
  #   it { should_not be_valid }
  # end

  describe "with placa that is too long" do
    before { @vehicle.placa = "a" * 8 }
    it { should_not be_valid }
  end

end
