require 'rails_helper'

RSpec.describe "Checkins", type: :request do
  describe "GET /checkins" do
    it "works! (now write some real specs)" do
      get checkins_path
      expect(response).to have_http_status(200)
    end
  end
end
