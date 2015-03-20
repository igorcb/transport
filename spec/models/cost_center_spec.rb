require 'spec_helper'

describe CostCenter do
  before do 
  	@cost_center = FactoryGirl.build(:cost_center)
  end

  subject {@cost_center}

  it { should respond_to(:descricao) }
end
