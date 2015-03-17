require 'spec_helper'

describe AccountBank do
  let(:client) { FactoryGirl.build(:client) }
  before do 
    @account_bank = client.account_banks.build(banco: '1', 
                                               agencia: '0000000', 
                                               favorecido: "Nome da pessoa que vai receber o pagamento",
                                               cpf_cnpj: "34.259.437/0001-66" )
  end
  
  subject { @account_bank } 
  
  it { should respond_to(:banco) }
  it { should respond_to(:agencia) }
  it { should respond_to(:conta_corrente) }
  it { should respond_to(:favorecido) }
  it { should respond_to(:cpf_cnpj) }
  it { should respond_to(:driver) }
  it { should respond_to(:client) }
end
