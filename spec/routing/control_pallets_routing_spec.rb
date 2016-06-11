require "spec_helper"

describe ControlPalletsController do
  describe "routing" do

    it "routes to #index" do
      get("/control_pallets").should route_to("control_pallets#index")
    end

    it "routes to #new" do
      get("/control_pallets/new").should route_to("control_pallets#new")
    end

    it "routes to #show" do
      get("/control_pallets/1").should route_to("control_pallets#show", :id => "1")
    end

    it "routes to #edit" do
      get("/control_pallets/1/edit").should route_to("control_pallets#edit", :id => "1")
    end

    it "routes to #create" do
      post("/control_pallets").should route_to("control_pallets#create")
    end

    it "routes to #update" do
      put("/control_pallets/1").should route_to("control_pallets#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/control_pallets/1").should route_to("control_pallets#destroy", :id => "1")
    end

  end
end
