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

  describe "GET /drivers/set-location" do
    it "routes to drivers#edit_location" do
      expect(get("/drivers/1/set-location")).to route_to("drivers#edit_location", id: '1')
    end
  end

  describe "PATCH /drivers/set-location" do
    it "routes to drivers#update_location" do
      expect(patch("/drivers/1/set-location")).to route_to("drivers#update_location", id: '1')
    end
  end

  describe "GET /drivers/bid-job" do
    it "routes to drivers#edit_bid" do
      expect(get("/drivers/1/bid-job")).to route_to("drivers#edit_bid", id: '1')
    end
  end

  describe "PATCH /drivers/bid-job" do
    it "routes to drivers#update_bid" do
      expect(patch("/drivers/1/bid-job")).to route_to("drivers#update_bid", id: '1')
    end
  end

  describe "GET /drivers/:id/jobs/on-process" do
    it "routes to orders#current_job" do
      expect(get("/drivers/1/jobs/on-process")).to route_to("drivers#current_job", id: '1')
    end
  end

  describe "PATCH /drivers/:id/jobs/on-process" do
    it "routes to orders#update_current_job" do
      expect(patch("/drivers/1/jobs/on-process")).to route_to("drivers#update_current_job", id: '1')
    end
  end

  describe "GET /drivers/:id/jobs/" do
    it "routes to drivers#jobs_index" do
      expect(get("/drivers/1/jobs")).to route_to("drivers#jobs_history", id: '1')
    end
  end
end
