require 'rails_helper'

RSpec.describe "ConferenceBreakdowns", type: :request do
  describe "GET /conference_breakdowns" do
    it "works! (now write some real specs)" do
      get conference_breakdowns_path
      expect(response).to have_http_status(200)
    end
  end
end
