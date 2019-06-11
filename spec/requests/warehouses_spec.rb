require 'rails_helper'

RSpec.describe "Warehouses", type: :request do
  describe "GET /warehouses" do
    it "works! (now write some real specs)" do
      get warehouses_path
      expect(response).to have_http_status(200)
    end
  end
end
