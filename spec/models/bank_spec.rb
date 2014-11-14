require 'spec_helper'

describe Bank do
  before do 
  	@bank = Bank.create(banco: "00001", nome: 'NOME DO BANCO')
  end

  subject { @bank }

  it { should respond_to(:banco) }
  it { should respond_to(:nome) }

  describe "when banco is not present" do
    before { @bank.banco = '' }
    it { should_not be_valid }
  end    

  describe "when banco that is too long" do
    before { @bank.banco = "0" * 6 }
    it { should_not be_valid }
  end    

  describe "when banco is not number" do
    before { @bank.banco = 'wwww' }
    it { should_not be_valid }
  end    

  describe "when nome is not present" do
    before { @bank.nome = '' }
    it { should_not be_valid }
  end    

  describe "when nome that is too long" do
    before { @bank.nome = "0" * 61 }
    it { should_not be_valid }
  end  
end
