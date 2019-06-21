require 'rails_helper'

RSpec.describe "Floors", type: :request do
  describe "GET /floors" do
    it "works! (now write some real specs)" do
      get floors_path
      expect(response).to have_http_status(200)
    end
  end
end
