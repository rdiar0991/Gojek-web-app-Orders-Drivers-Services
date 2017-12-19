require 'rails_helper'

RSpec.describe 'Orders API', type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe "GET /api/v1/orders" do

    context "with params[:user_id] and records exist" do
      before :each do
        create(:order, user_id: user.id, status: "Complete", driver_id: 1)
        create(:order, user_id: user.id, status: "Complete", driver_id: 2)
        create(:order, user_id: another_user.id, status: "Complete", driver_id: 2)
        get "/api/v1/orders?user_id=#{user.id}"
      end

      it "returns orders which associated to user" do
        expect(json).not_to be_empty
        expect(json.size).to eq(2)
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end
    end
    context "with params[:user_id] and records does not exist" do
      before { get "/api/v1/orders?user_id=-1" }

      it "returns a not found message" do
        expect(response.body).to eq("{\"message\":\"Couldn't find User with 'id'=-1\"}")
      end
      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end
    end

    context "without params" do
      before { get "/api/v1/orders" }

      it "returns empty page" do
        expect(response.body).to be_empty
      end
    end

  end
end
