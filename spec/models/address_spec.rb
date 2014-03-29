require 'spec_helper'

describe Address do
  before { @address = Address.new(tipo: '1',
  																logradouro: "Rua Libania",
  	                              bairro: "Serrinha",
  	                              estado: "CE",
  	                              cidade: 'Fortaleza',
  	                              cep: '60742300' 
  	                              ) }

  subject { @address }

  it { should respond_to(:tipo) }
  it { should respond_to(:logradouro) }
  it { should respond_to(:bairro) }
  it { should respond_to(:estado) }
  # it { should respond_to(:cidade) }
  # it { should respond_to(:cep) }
  # it { should respond_to(:persons) }
  # it { should respond_to(:clients) }
  # it { should accept_nested_attributes_for :clients }

  # describe "when tipo is not present" do
  #   before { @address.tipo = ' ' }
  #   it { should_not be_valid }
  # end

  # describe "when logradouro is not present" do
  #   before { @address.logradouro = ' ' }
  #   it { should_not be_valid }
  # end

  # describe "when bairro is not present" do
  #   before { @address.bairro = ' ' }
  #   it { should_not be_valid }
  # end

  # describe "when cidade is not present" do
  #   before { @address.cidade = ' ' }
  #   it { should_not be_valid }
  # end

  # describe "when cep is not present" do
  #   before { @address.cep = ' ' }
  #   it { should_not be_valid }
  # end

  # describe "when cep is too long" do
  #   before { @address.cep = "a" * 9 }
  #    it { should_not be_valid }
  # end

  # describe "when cep is already taken" do
  #   before do
  #     address_with_cep = @address.dup
  #     address_with_cep.cep = @address.cep
  #     address_with_cep.save
  #   end

  #   it { should_not be_valid }
  # end  
end 
