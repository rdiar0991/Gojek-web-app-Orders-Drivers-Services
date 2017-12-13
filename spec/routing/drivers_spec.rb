require "rails_helper"

RSpec.describe "Drivers routing", type: :routing do
  describe "GET /drivers/signup" do
    it "routes to drivers#new" do
      expect(get("/drivers/signup")).to route_to("drivers#new")
    end
  end

  describe "POST /drivers/signup" do
    it "routes to drivers#create" do
      expect(post("/drivers/signup")).to route_to("drivers#create")
    end
  end
end
