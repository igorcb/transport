require 'spec_helper'

describe OrdemService do
  before do 
  	@ordem_service = OrdemService.create( driver_id: 1,
						                              client_id: 1, 
						                                   data: '2014-12-01',
						                     							placa: 'AUH-0000',
						                                 estado: 'CE',
						                                 cidade: 'FORTALEZA', 
						                                    cte: '0000001',
						                              danfe_cte: '0000001',
						                          valor_receita: 0.00,
						                          valor_despesas: 0.00,
						                          valor_liquido: 0.00,
						                                 status: 0,
						                        data_fechamento: '2014-12-01',
						                            qtde_volume: 1.001,
						                                   peso: 1.002,
						                             billing_id: 0,
						                   data_entrega_servico: '2014-12-01',
						                            senha_sefaz: 'a12zlkx',
						                                   tipo: 0
						                                 ) 

  end

	subject { @ordem_service }

	it { should respond_to(:driver_id) }
	it { should respond_to(:client_id) }
	it { should respond_to(:data) }
	it { should respond_to(:placa) }
	it { should respond_to(:estado) }
	it { should respond_to(:cidade) }
	it { should respond_to(:cte) }
	it { should respond_to(:danfe_cte) }
	it { should respond_to(:valor_receita) }
	it { should respond_to(:valor_despesas) }
	it { should respond_to(:valor_liquido) }
	it { should respond_to(:status) }
	it { should respond_to(:qtde_volume) }
	it { should respond_to(:peso) }
	it { should respond_to(:billing_id) }
	it { should respond_to(:data_entrega_servico) }
	it { should respond_to(:senha_sefaz) }
	it { should respond_to(:tipo) }
	it { should respond_to(:driver) }
	it { should respond_to(:client) }
	it { should respond_to(:nfe_keys) }
	it { should respond_to(:ordem_service_type_service) }
	it { should respond_to(:assets) }
	it { should accept_nested_attributes_for :ordem_service_type_service }
	it { should accept_nested_attributes_for :assets }

  describe "when driver is not present" do
    before { @ordem_service.driver_id = '' }
    it { should_not be_valid }
  end  
  
  describe "when client is not present" do
    before { @ordem_service.client_id = '' }
    it { should_not be_valid }
  end  

  describe "when placa is not present" do
    before { @ordem_service.placa = '' }
    it { should_not be_valid }
  end  

  describe "when estado is not present" do
    before { @ordem_service.estado = '' }
    it { should_not be_valid }
  end  

  describe "when cidade is not present" do
    before { @ordem_service.cidade = '' }
    it { should_not be_valid }
  end  

  describe "when cte is not present" do
    before { @ordem_service.cte = '' }
    it { should_not be_valid }    
  end  

  describe "with cte that is too long" do
    before { @ordem_service.cte = "a" * 21 }
    it { should_not be_valid }
  end  
  
  describe "with cte that is not number" do
    before { @ordem_service.cte = "XXXXXX" }
    it { should_not be_valid }
  end  
  
end

