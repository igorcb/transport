require "rails_helper"

RSpec.describe CheckinsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/checkins").to route_to("checkins#index")
    end

    it "routes to #new" do
      expect(:get => "/checkins/new").to route_to("checkins#new")
    end

    it "routes to #show" do
      expect(:get => "/checkins/1").to route_to("checkins#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/checkins/1/edit").to route_to("checkins#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/checkins").to route_to("checkins#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/checkins/1").to route_to("checkins#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/checkins/1").to route_to("checkins#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/checkins/1").to route_to("checkins#destroy", :id => "1")
    end
  end
end
