require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  before :each do
    @user = create(:user)
  end

  describe "GET #new" do
    before :each do
      log_in_as @user
      get :new, params: { user_id: session[:user_id], order: attributes_for(:order) }
    end
    it "renders the :new order template" do
      expect(response).to render_template(:new)
    end
    it "assigns order to be a new Order" do
      expect(assigns[:order]).to be_a_new(Order)
    end
  end

  describe "POST #create" do
    before :each do
      log_in_as @user
    end
    context "with valid attributes" do
      it "does not saves new order in the database" do
        expect{
          post :create, params: { user_id: session[:user_id], order: attributes_for(:order) }
        }.not_to change(Order, :count)
      end
      it "renders the order confirm page" do
        post :create, params: { user_id: session[:user_id], order: attributes_for(:order) }
        expect(response).to render_template :confirm_order
      end
      it "assigns order price" do
        post :create, params: { user_id: session[:user_id], order: attributes_for(:order) }
        expect(assigns[:order].price).not_to eq(nil)
      end
      it "assigns order distance" do
        post :create, params: { user_id: session[:user_id], order: attributes_for(:order) }
        expect(assigns[:order].distance).not_to eq(nil)
      end
    end

    context "with invalid attributes" do
      it "does not save new order in the database" do
        expect{
          post :create, params: { user_id: session[:user_id], order: attributes_for(:invalid_order) }
        }.not_to change(Order, :count)
      end
      it "re-renders the :new order template" do
        post :create, params: { user_id: session[:user_id], order: attributes_for(:invalid_order) }
        expect(response).to render_template :new
      end
    end
  end
end
