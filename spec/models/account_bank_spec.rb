require 'spec_helper'

describe AccountBank do
  before do 
  	@account_bank = AccountBank.create(banco: '1', 
  																		 agencia: '0000000', 
  																		 conta_corrente: '0000000000', 
  																		 favorecido: "Nome da pessoa que vai receber o pagamento", 
  																		 cpf_cnpj: "34.259.437/0001-66" 
  																		 #account_id: id do Driver ou Client
  																		 #contact_type: Driver, Client
  																			)
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
