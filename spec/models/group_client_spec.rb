require 'spec_helper'

describe GroupClient do
	before do 
  	@group_client = GroupClient.create(descricao: 'SERVMASTER')
  end

  subject { @group_client}

  it { should respond_to(:descricao) }
  it { should respond_to(:clients) }

  describe "when descricao is not present" do
    before { @group_client.descricao = '' }
    it { should_not be_valid }
  end  

  describe "when descricao is already taken" do
  	before do
  		@group = GroupClient.create(descricao: 'SERVMASTER')
  	end
    it { should_not be_valid }
  end

end
