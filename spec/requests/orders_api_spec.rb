require 'rails_helper'

RSpec.describe 'Orders API', type: :request do
  let(:user) { create(:user) }
  let(:driver) { create(:driver) }
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

  describe "POST /api/v1/orders" do
    let(:valid_attributes) { {"origin"=>"Dufan, Jakarta", "destination"=>"Kolla Space Sabang", "distance"=>"13.6", "payment_type"=>"GoPay", "price"=>"34000.0", "user_id"=>user.id, "service_type"=>"Go-Car"} }
    context "with valid attributes" do
      before { post "/api/v1/orders", params: valid_attributes }

      it 'creates an order' do
        expect(json['origin']).to eq('Dufan, Jakarta')
      end
      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end

    end

    context "with invalid attributes" do
      before { post "/api/v1/orders", params: { origin: "Sarinah, Jakarta", destination: nil, payment_type: nil } }

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "GET /api/v1/show/" do
    context "with params[:user_id]" do
      before :each do
        @user2 = create(:user)
        @driver2 = create(:driver)
        @order = create(:order, status: "On the way", user_id: @user2.id, driver_id: @driver2.id)
        get "/api/v1/orders/show?user_id=#{@user2.id}"
      end

      it "returns user's active order" do
        expect(json).not_to eq(nil)
      end
      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end

    end

    context "when user has no active order" do
      before :each do
        @user2 = create(:user)
        @driver2 = create(:driver)
        @order = create(:order, status: "Complete", user_id: @user2.id, driver_id: @driver2.id)
        get "/api/v1/orders/show?user_id=#{@user2.id}"
      end

      it "returns null json" do
        expect(response.body).to eq('null')
      end
    end

    context "without params" do
      before { get "/api/v1/orders/show" }
      it "returns empty page" do
        expect(response.body).to be_empty
      end
    end
  end


end
