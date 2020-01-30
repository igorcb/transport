require "rails_helper"

RSpec.describe DevolutionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/devolutions").to route_to("devolutions#index")
    end

    it "routes to #new" do
      expect(:get => "/devolutions/new").to route_to("devolutions#new")
    end

    it "routes to #show" do
      expect(:get => "/devolutions/1").to route_to("devolutions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/devolutions/1/edit").to route_to("devolutions#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/devolutions").to route_to("devolutions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/devolutions/1").to route_to("devolutions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/devolutions/1").to route_to("devolutions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/devolutions/1").to route_to("devolutions#destroy", :id => "1")
    end
  end
end
