require "spec_helper"

describe OccurrencesController do
  describe "routing" do

    it "routes to #index" do
      get("/occurrences").should route_to("occurrences#index")
    end

    it "routes to #new" do
      get("/occurrences/new").should route_to("occurrences#new")
    end

    it "routes to #show" do
      get("/occurrences/1").should route_to("occurrences#show", :id => "1")
    end

    it "routes to #edit" do
      get("/occurrences/1/edit").should route_to("occurrences#edit", :id => "1")
    end

    it "routes to #create" do
      post("/occurrences").should route_to("occurrences#create")
    end

    it "routes to #update" do
      put("/occurrences/1").should route_to("occurrences#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/occurrences/1").should route_to("occurrences#destroy", :id => "1")
    end

  end
end
