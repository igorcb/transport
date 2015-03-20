require 'spec_helper'

describe SubCostCenter do
	let(:cost_center) {FactoryGirl.build(:cost_center)}
  before do 
  	#@sub_cost_center = FactoryGirl.build(:cost_center)
  	@sub_cost_center = cost_center.sub_cost_centers.build(descricao: "MATERIAL DE LIMPEZA")
  end

  subject {@sub_cost_center}

  it { should respond_to(:cost_center_id) }
  it { should respond_to(:descricao) }

  it { should respond_to(:cost_center) }

end
