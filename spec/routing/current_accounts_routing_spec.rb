require "spec_helper"

describe CurrentAccountsController do
  describe "routing" do

    it "routes to #index" do
      get("/current_accounts").should route_to("current_accounts#index")
    end

    it "routes to #new" do
      get("/current_accounts/new").should route_to("current_accounts#new")
    end

    it "routes to #show" do
      get("/current_accounts/1").should route_to("current_accounts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/current_accounts/1/edit").should route_to("current_accounts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/current_accounts").should route_to("current_accounts#create")
    end

    it "routes to #update" do
      put("/current_accounts/1").should route_to("current_accounts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/current_accounts/1").should route_to("current_accounts#destroy", :id => "1")
    end

  end
end
