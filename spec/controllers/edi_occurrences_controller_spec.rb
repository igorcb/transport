require 'rails_helper'

RSpec.describe EdiOccurrencesController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @current_user = FactoryBot.create(:user)
    sign_in @current_user
  end

  describe "#generate_file" do

    context "return msg nfe not select" do
      it "when not exist params NFe" do
        get :generate_file
        expect(response).to redirect_to(edi_occurrences_path)
        expect(flash[:danger]).to match("Select one nfe.")
      end
    end

    context "return msg nfe select" do
      it "when exist params NFe" do
        nfe_key = NfeKey.first
        ordem_service = nfe_key.ordem_service
        input_control = ordem_service.input_control

        ordem_service.billing_client_id = input_control.billing_client_id
        ordem_service.data_entrega_servico = Date.current
        nfe_key.ordem_service.save!
        nfe_key.reload

        key = nfe_key.id
        value = nfe_key.id

        get :generate_file, params: {nfe: {ids: {key => value} }  }
        expect(response).to redirect_to(edi_occurrences_path)
        expect(flash[:success]).to match("File generate success")
      end
    end

  end
end
