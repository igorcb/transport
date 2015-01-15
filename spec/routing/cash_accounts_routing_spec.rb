require "spec_helper"

describe CashAccountsController do
  describe "routing" do

    it "routes to #index" do
      get("/cash_accounts").should route_to("cash_accounts#index")
    end

    it "routes to #new" do
      get("/cash_accounts/new").should route_to("cash_accounts#new")
    end

    it "routes to #show" do
      get("/cash_accounts/1").should route_to("cash_accounts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/cash_accounts/1/edit").should route_to("cash_accounts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/cash_accounts").should route_to("cash_accounts#create")
    end

    it "routes to #update" do
      put("/cash_accounts/1").should route_to("cash_accounts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/cash_accounts/1").should route_to("cash_accounts#destroy", :id => "1")
    end

  end
end
