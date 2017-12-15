require 'rails_helper'

RSpec.describe 'Users Routing', type: :routing do
  describe "GET /users/signup" do
    it "routes to users#new" do
      expect(get("/users/signup")).to route_to("users#new")
    end
  end

  describe "POST /users/signup" do
    it "routes to users#create" do
      expect(post("/users/signup")).to route_to("users#create")
    end
  end

  describe "GET /users/:id/topup" do
    it "routes to users#topup_gopay" do
      expect(get: "/users/1/topup").to route_to("users#topup_gopay", id: '1')
    end
  end

  describe "PATCH /users/:id/topup" do
    it "routes to users#update_gopay" do
      expect(patch("/users/1/topup")).to route_to("users#update_gopay", id: '1')
    end
  end

  describe "GET /users/:user_id/orders/new" do
    it "routes to orders#new" do
      expect(get: "/users/1/orders/new").to route_to("orders#new", user_id: '1')
    end
  end

  describe "GET /users/:user_id/orders/new" do
    it "routes to orders#create" do
      expect(get: "/users/1/orders/create").to route_to("orders#create", user_id: '1')
    end
  end

  describe "GET /users/:user_id/orders/confirm" do
    it "routes to orders#confirm_order" do
      expect(get: "/users/1/orders/confirm").to route_to("orders#confirm_order", user_id: '1')
    end
  end

  describe "POST /users/:user_id/orders/confirm" do
    it "routes to orders#commit_order" do
      expect(post: "/users/1/orders/confirm").to route_to("orders#commit_order", user_id: '1')
    end
  end

  describe "GET /users/:id/orders/on-process" do
    it "routes to orders#current_order" do
      expect(get("/users/1/orders/on-process")).to route_to("users#current_order", id: '1')
    end
  end
end
