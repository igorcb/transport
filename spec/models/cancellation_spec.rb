require 'spec_helper'

describe Cancellation do
  before do
  	@cancellation = Cancellation.create(solicitation_user_id: 1,
    																		authorization_user_id: 1,
    																		status: 0,
    																		observacao: "Vestibulum iaculis",
    																		cancel_id: 1,
    																		cancel_type: "OS", )
  end

  subject {@cancellation}
  it {should respond_to(:solicitation_user_id)}
  it {should respond_to(:authorization_user_id)}
  it {should respond_to(:status)}
  it {should respond_to(:observacao)}
  it {should respond_to(:cancel_id)}
  it {should respond_to(:cancel_type)}
  it {should respond_to(:solicitation_user)}
  it {should respond_to(:authorization_user)}
  it {should respond_to(:ordem_service)}

  describe "when solicitation_user_id is not present" do
    before { @cancellation.solicitation_user_id = '' }
    it { should_not be_valid }
  end   

  describe "when authorization_user_id is not present" do
    before { @cancellation.authorization_user_id = '' }
    it { should_not be_valid }
  end   

  describe "when observacao is not present" do
    before { @cancellation.observacao = '' }
    it { should_not be_valid }
  end   

  describe "when the observacao is small" do
    before { @cancellation.observacao = 'a' * 14 }
    it { should_not be_valid }
  end   

end
