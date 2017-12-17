require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  before :each do
    @user = create(:user)
  end

  describe "GET #new" do
    before :each do
      log_in_as @user
    end
    context "user have no an active order" do
      before { get :new, params: { user_id: @user.id, order: attributes_for(:order) } }
      it "renders the :new order template" do
        expect(response).to render_template(:new)
      end
      it "assigns order to be a new Order" do
        expect(assigns[:order]).to be_a_new(Order)
      end
    end
    context "user already have an active order" do
      before :each do
        @driver = create(:driver)
        @order = create(:order, user_id: @user.id, status: "On the way", driver_id: @driver.id)
        get :new, params: { user_id: @user.id, order: attributes_for(:order) }
      end
      it "sets flash[:danger] message" do
        expect(flash[:danger]).to match(/Can't create new one, you already have an active order./)
      end
      it "redirects to the current_order_path" do
        expect(response).to redirect_to current_order_path(@user)
      end
    end
  end

  describe "GET #create" do
    before :each do
      log_in_as @user
    end
    context "with valid attributes" do
      it "does not saves new order in the database" do
        expect{
          get :create, params: { user_id: session[:user_id], order: attributes_for(:order) }
        }.not_to change(Order, :count)
      end
      it "renders the order confirm page" do
        get :create, params: { user_id: session[:user_id], order: attributes_for(:order) }
        expect(response).to render_template :confirm_order
      end
      it "assigns order price" do
        get :create, params: { user_id: session[:user_id], order: attributes_for(:order) }
        expect(assigns[:order].price).not_to eq(nil)
      end
      it "assigns order distance" do
        get :create, params: { user_id: session[:user_id], order: attributes_for(:order) }
        expect(assigns[:order].distance).not_to eq(nil)
      end
    end

    context "with invalid attributes" do
      it "does not save new order in the database" do
        expect{
          get :create, params: { user_id: session[:user_id], order: attributes_for(:invalid_order) }
        }.not_to change(Order, :count)
      end
      it "re-renders the :new order template" do
        get :create, params: { user_id: session[:user_id], order: attributes_for(:invalid_order) }
        expect(response).to render_template :new
      end
    end
    context "with insufficient gopay balance" do
      before :each do
        get :create, params: { user_id: session[:user_id], order: attributes_for(:order, price: 10000.0, payment_type: "GoPay") }
      end

      it "re-renders the :new order" do
        expect(response).to render_template :new
      end
      it "sets flash.now[:danger] message" do
        expect(flash.now[:danger]).to match(/Whoops, your gopay balance is not suffiecient. Try another payment type./)
      end
    end
  end

  describe "POST #commit_order" do
    before :each do
      @user = create(:user)
      log_in_as @user
      @order = create(:order, user_id: @user.id, origin: "Wisma Naelah", destination: "Monas, Jakarta")
    end
    context "valid attributes" do
      before :each do
        post :commit_order, params: { user_id: @user.id, order: attributes_for(:order) }
      end

      it "assigns order's status to 'Looking for driver'" do
        expect(assigns[:order].status).to match(/Looking for driver/)
      end

      it "redirects to current_order_path" do
        expect(response).to redirect_to current_order_path(@user)
      end
    end

    context "with invalid order" do
      it "redirects to the new order path" do
        post :commit_order, params: { user_id: @user.id, order: attributes_for(:invalid_order) }
        expect(response).to redirect_to new_order_path(@user)
      end
    end
  end
end
