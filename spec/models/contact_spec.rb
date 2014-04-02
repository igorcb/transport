require 'spec_helper'

describe Contact do
	let(:client) { FactoryGirl.create(:client) }

  before { @contact = Contact.create(tipo: Contact::TipoContato::FIXO,
                                     nome: "Joao",
                                     fone: "8532326790",
                              complemento: "")
                            
                              }

  subject { @contact }

  it { should respond_to(:tipo) }
  it { should respond_to(:nome) }
  it { should respond_to(:fone) }
  it { should respond_to(:complemento) }
  it { should respond_to(:contact_id) }
  it { should respond_to(:contact_type) }
  it { should respond_to(:client) }

  describe "when tipo is not present" do
    before { @contact.tipo = ' ' }
    it { should_not be_valid }
  end  

  describe "when nome is not present" do
    before { @contact.nome = ' ' }
    it { should_not be_valid }
  end  

  describe "when fone is not present" do
    before { @contact.fone = ' ' }
    it { should_not be_valid }
  end  

  describe "when contact_id is not present" do
    before { @contact.contact_id = ' ' }
    it { should_not be_valid }
  end  

  describe "when contact_type is not present" do
    before { @contact.contact_type = ' ' }
    it { should_not be_valid }
  end  

  describe "with nome that is too long" do
    before { @contact.nome = "a" * 31 }
    it { should_not be_valid }
  end  

end
