require "rails_helper"

RSpec.describe WarehousesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/warehouses").to route_to("warehouses#index")
    end

    it "routes to #new" do
      expect(:get => "/warehouses/new").to route_to("warehouses#new")
    end

    it "routes to #show" do
      expect(:get => "/warehouses/1").to route_to("warehouses#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/warehouses/1/edit").to route_to("warehouses#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/warehouses").to route_to("warehouses#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/warehouses/1").to route_to("warehouses#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/warehouses/1").to route_to("warehouses#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/warehouses/1").to route_to("warehouses#destroy", :id => "1")
    end
  end
end
