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
  end

  describe "POST #commit_order" do
    before :each do
      @user = create(:user)
      # @driver_amer = create(:driver, bid_status: "Online", current_coord: "-6.188278899999999, 106.8180238")
      # @driver_baehan = create(:driver, bid_status: "Online", current_coord: "-6.189052999999999, 106.8205542")
      # @driver_kuroky = create(:driver, bid_status: "Online", current_coord: "-9.189052999999999, 103.8205542")
      # @online_drivers = {@driver_amer.id => [-6.188278899999999, 106.8180238], @driver_baehan.id => [-6.189052999999999, 106.8205542], @driver_kuroky.id => [-9.189052999999999, 103.8205542]}
      # @drivers_around = { @driver_amer.id => 92.70063515197491, @driver_baehan.id => 290.20402857808995 }
      # @wisma_naelah_coord = [-6.1891073, 106.8179296] # {:lat=>-6.1891073, :lng=>106.8179296}
      @order = create(:order, user_id: @user.id, origin: "Wisma Naelah", destination: "Monas, Jakarta")
    end
    context "valid attributes" do
      before :each do
        log_in_as @user
        post :commit_order, params: { user_id: @user.id, order: attributes_for(:order) }
      end

      # Shall not pass due to ActiveJob implementation
      #
      # it "assigns[:origin_coordinates] to eq origin's corrdinates" do
      #   expect(assigns[:origin_coordinates]).to eq(@wisma_naelah_coord)
      # end
      # it "collects the online drivers" do
      #   expect(assigns[:online_drivers]).to eq(@online_drivers)
      # end
      # it "collects the drivers around user" do
      #   expect(assigns[:driver_around_users]).to eq(@drivers_around)
      # end

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
