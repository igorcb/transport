require 'rails_helper'

RSpec.describe ControlPalletsController, type: :controller do
  login_admin

  def valid_attributes
    {  }
  end

  def valid_session
    { temp: "test" }
  end

  it "should have a current_user" do
    # note the fact that you should remove the "validate_session" parameter if this was a scaffold-generated controller
    expect(subject.current_user).to_not eq(nil)
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  # describe "GET #new" do
  #   it "returns a success response" do
  #     get :new
  #     expect(response).to be_successful
  #     # expect(response.status).to eq(200)
  #     #response.should be_success
  #   end
  # end

  # describe "GET #new" do
  #   it "assigns a new control_pallet as @control_pallet" do
  #     get :new, {}
  #     assigns(:control_pallet).should be_a_new(ControlPallet)
  #   end
  # end
end
