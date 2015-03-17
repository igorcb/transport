require 'spec_helper'

describe Stretch do
   before do 
  	#@stretch = Stretch.create(cidade: 'FORTALEZA', estado: "CE", destino: "NAT")
  	@stretch = FactoryGirl.build(:stretch)
  end
  
  subject { @stretch } 

  it { should respond_to(:cidade) }
  it { should respond_to(:estado) }
  it { should respond_to(:destino) }

  describe "when cidade is not present" do
    before { @stretch.cidade = '' }
    it { should_not be_valid }
  end  

  describe "when estado is not present" do
    before { @stretch.estado = '' }
    it { should_not be_valid }
  end  

  describe "when destino is not present" do
    before { @stretch.destino = '' }
    it { should_not be_valid }
  end  

  describe "with cidade that is too long" do
    before { @stretch.cidade = "a" * 21 }
    it { should_not be_valid }
  end

  describe "with estado that is too long" do
    before { @stretch.estado = "a" * 3 }
    it { should_not be_valid }
  end

  describe "with destino that is too long" do
    before { @stretch.destino = "a" * 4 }
    it { should_not be_valid }
  end
end
