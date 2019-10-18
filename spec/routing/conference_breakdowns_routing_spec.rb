require "rails_helper"

RSpec.describe ConferenceBreakdownsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/conference_breakdowns").to route_to("conference_breakdowns#index")
    end

    it "routes to #new" do
      expect(:get => "/conference_breakdowns/new").to route_to("conference_breakdowns#new")
    end

    it "routes to #show" do
      expect(:get => "/conference_breakdowns/1").to route_to("conference_breakdowns#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/conference_breakdowns/1/edit").to route_to("conference_breakdowns#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/conference_breakdowns").to route_to("conference_breakdowns#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/conference_breakdowns/1").to route_to("conference_breakdowns#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/conference_breakdowns/1").to route_to("conference_breakdowns#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/conference_breakdowns/1").to route_to("conference_breakdowns#destroy", :id => "1")
    end
  end
end
