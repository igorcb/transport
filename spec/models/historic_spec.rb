require 'spec_helper'

describe Historic do
  before do 
  	@historic = FactoryGirl.build(:historic)
  end

  subject {@historic}

  it { should respond_to(:descricao) }
end
