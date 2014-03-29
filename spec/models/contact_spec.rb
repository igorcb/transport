require 'spec_helper'

describe Contact do
	let(:person) { FactoryGirl.create(:person) }
  before { @contact = Contact.create(tipo: Contact::TipoContato::FIXO,
  	                              nome: "Joao",
  	                              fone: "8532326790",
  	                       complemento: "",
  	                          pessoa_id: person.id) }

  subject { @contact }

  # it { should respond_to(:tipo) }
  # it { should respond_to(:nome) }
  # it { should respond_to(:fone) }
  # it { should respond_to(:complemento) }


end
