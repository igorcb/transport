require 'rails_helper'

RSpec.describe OrdemServicesController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @current_user = User.first
    sign_in @current_user
  end

  describe "GET #show" do

    context "ordem service exists" do
      # context "User is the owner of the campaing" do
      it "Returns success" do
        get :show, params: {id: OrdemService.first.id}
        expect(response).to have_http_status(:success)
      end
    end

    context "ordem service delivery" do
      # context "User is the owner of the campaing" do
      it "Returns success" do
        get :delivery, params: {id: OrdemService.first.id}
        expect(response).to have_http_status(:success)
      end
    end

    context "ordem service update delivery" do
      # context "User is the owner of the campaing" do
      it "Returns success" do
        post :update_delivery, params: {id: OrdemService.first.id}
        expect(response).to have_http_status(:success)
      end
    end

  end
end
