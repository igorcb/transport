require "spec_helper"

describe SubCostCenterThreesController do
  describe "routing" do

    it "routes to #index" do
      get("/sub_cost_center_threes").should route_to("sub_cost_center_threes#index")
    end

    it "routes to #new" do
      get("/sub_cost_center_threes/new").should route_to("sub_cost_center_threes#new")
    end

    it "routes to #show" do
      get("/sub_cost_center_threes/1").should route_to("sub_cost_center_threes#show", :id => "1")
    end

    it "routes to #edit" do
      get("/sub_cost_center_threes/1/edit").should route_to("sub_cost_center_threes#edit", :id => "1")
    end

    it "routes to #create" do
      post("/sub_cost_center_threes").should route_to("sub_cost_center_threes#create")
    end

    it "routes to #update" do
      put("/sub_cost_center_threes/1").should route_to("sub_cost_center_threes#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/sub_cost_center_threes/1").should route_to("sub_cost_center_threes#destroy", :id => "1")
    end

  end
end
