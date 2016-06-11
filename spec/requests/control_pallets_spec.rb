require 'spec_helper'

describe "ControlPallets" do
  describe "GET /control_pallets" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get control_pallets_path
      response.status.should be(200)
    end
  end
end
