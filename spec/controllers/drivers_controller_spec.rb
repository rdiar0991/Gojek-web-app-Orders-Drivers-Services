require 'rails_helper'

RSpec.describe DriversController, type: :controller do
  describe "GET #show" do
    before :each do
      @driver = create(:driver)
      @another_driver = create(:driver)
    end

    context "with logged-in and authorized driver" do
      before :each do
        log_in_as @driver
        get :show, params: { id: @driver.id }
      end
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "shows the requested driver" do
        expect(assigns[:driver]).to eq(@driver)
      end
      it "renders the :show template" do
        expect(response).to render_template(:show)
      end
    end
    context "with logged-in and un-authorized driver" do
      before :each do
        log_in_as @another_driver
        get :show, params: { id: @driver.id }
      end
      it "redirects to the profile page" do
        expect(response).to redirect_to @another_driver
      end
    end
    context "with non-logged in and un-authorized driver" do
      before :each do
        get :show, params: { id: @driver.id }
      end
      it "redirects to the login page" do
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "GET #new" do
    before { get :new }
    it "assigns a new Driver to @driver" do
      expect(assigns[:driver]).to be_a_new(Driver)
    end
    it "renders the :new template" do
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves new driver in the database" do
        expect{
          post :create, params: { driver: attributes_for(:driver) }
        }.to change(Driver, :count).by(1)
      end

      it "sets new sessions for driver login automatically" do
        post :create, params: { driver: attributes_for(:driver) }
        expect(session[:user_id]).not_to eq(nil)
        expect(session[:role]).not_to eq(nil)
      end

      it "sets gopay_balance balance default 0.0" do
        post :create, params: { driver: attributes_for(:driver) }
        expect(assigns[:driver].gopay_balance).to eq(0.0)
      end
      it "redirects to the driver's profile page" do
        post :create, params: { driver: attributes_for(:driver) }
        expect(response).to redirect_to(driver_path(assigns[:driver]))
      end
    end

    context "with invalid attributes" do
      it "does not save user to the database" do
        expect{
          post :create, params: { driver: attributes_for(:driver, name: nil, email: nil) }
        }.not_to change(Driver, :count)
      end
      it "re-renders the :new template" do
        post :create, params: { driver: attributes_for(:driver, name: nil, email: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    before :each do
      @driver = create(:driver)
      @another_driver = create(:driver)
    end

    context "with logged-in and authorized driver" do
      before :each do
        log_in_as(@driver)
        get :edit, params: { id: @driver.id }
      end
      it "locates the requested driver to @driver" do
        expect(assigns[:driver]).to eq(@driver)
      end
      it "renders the :edit template" do
        expect(response).to render_template(:edit)
      end
    end

    context "logged-in and un-authorized driver" do
      before :each do
        log_in_as(@another_driver)
        get :edit, params: { id: @driver.id }
      end
      it "redirects to the profile page" do
        expect(response).to redirect_to(@another_driver)
      end
    end

    context "with non-logged and un-authorized in driver" do
      it "redirects to the login page" do
        get :edit, params: { id: @driver.id }
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "PATCH #update" do
    before :each do
      @driver = create(:driver, name: "anugrah")
      @another_driver = create(:driver)
    end

    context "with logged-in and authorized driver" do
      context "with valid attributes" do
        before :each do
          log_in_as @driver
          patch :update, params: { id: @driver.id, driver: attributes_for(:driver, name: "marzan") }
        end
        it "locates the requested driver to @driver" do
          expect(assigns[:driver]).to eq(@driver)
        end
        it "updates the driver's attributes in the database" do
          @driver.reload
          expect(@driver.name).to match(/marzan/)
        end
        it "redirects to the profile page" do
          expect(response).to redirect_to(@driver)
        end
      end
      context "with invalid attributes" do
        before :each do
          log_in_as @driver
          patch :update, params: { id: @driver.id, driver: attributes_for(:driver, name: "marzan", email: nil) }
        end
        it "does not updates the driver in the database" do
          @driver.reload
          expect(@driver.name).not_to match(/marzan/)
        end
        it "re-renders the :edit template" do
          expect(response).to render_template(:edit)
        end
      end
    end
    context "with logged-in and un-authorized driver" do
      before :each do
        log_in_as @another_driver
        patch :update, params: { id: @driver.id, driver: attributes_for(:driver, name: "marzan") }
      end
      it "redirects to the profile page" do
        expect(response).to redirect_to @another_driver
      end
    end
    context "with non-logged in and un-authorized driver" do
      it "redirects to the login page" do
        patch :update, params: { id: @driver.id, driver: attributes_for(:driver, name: "marzan") }
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "GET #edit_location" do
    before :each do
      @driver = create(:driver)
      @another_driver = create(:driver)
    end

    context "with logged-in and authorized driver" do
      before :each do
        log_in_as @driver
        get :edit_location, params: { id: @driver.id }
      end
      it "locates the requested driver to @driver" do
        expect(assigns[:driver]).to eq(@driver)
      end
      it "renders the :edit_location template" do
        expect(response).to render_template :edit_location
      end
    end
    context "with logged-in and un-authorized driver" do
      before :each do
        log_in_as @another_driver
        get :edit_location, params: { id: @driver.id }
      end
      it "redirects to the profile page" do
        expect(response).to redirect_to @another_driver
      end
    end
    context "with non-logged in and un-authorized driver" do
      it "redirects to the login page" do
        get :edit_location, params: { id: @driver.id }
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "PATCH #update_location" do
    before :each do
      @driver = create(:driver)
      @another_driver = create(:driver)
    end

    context "with logged-in and authorized driver" do
      before :each do
        log_in_as @driver
      end
      context "with valid :current_location" do
        before :each do
          patch :update_location, params: { id: @driver.id, driver: attributes_for(:driver, current_location: "Sarinah, Jakarta") }
        end
        it "locates the requested @driver" do

        end
        it "changes the driver's current_location attributes in the database" do
          @driver.reload
          expect(@driver.current_location).to match(/Sarinah, Jakarta/)
        end
        it "changes the driver's current_coord attributes in the database" do
          @driver.reload
          expect(@driver.current_coord).to match(/-6.1877157, 106.8238402/)
        end
        it "redirects to the profile page" do
          expect(response).to redirect_to @driver
        end
      end
      context "with invalid :current_location" do
        before :each do
          patch :update_location, params: { id: @driver.id, driver: attributes_for(:driver, current_location: "Lokasi yang tak diriundukan...Lul") }
        end
        it "does not update current_location in the database" do
          @driver.reload
          expect(@driver.current_location).not_to match(/Lokasi yang tak diriundukan...Lul/)
        end
        it "re-renders the :edit_location template" do
          expect(response).to render_template :edit_location
        end
      end
    end
    context "with logged-in and un-authorized driver" do
      before :each do
        log_in_as @another_driver
        patch :update_location, params: { id: @driver.id, driver: attributes_for(:driver, current_location: "Sarinah, Jakarta") }
      end
      it "redirects to the profile page" do
        expect(response).to redirect_to @another_driver
      end
    end
    context "with non-logged in and un-authorized driver" do
      it "redirects to the login page" do
        patch :update_location, params: { id: @driver.id, driver: attributes_for(:driver, current_location: "Sarinah, Jakarta") }
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "GET #edit_bid" do
    before :each do
      @driver = create(:driver)
      @another_driver = create(:driver)
    end

    context "with logged-in and authorized driver" do
      before :each do
        log_in_as @driver
        get :edit_bid, params: { id: @driver.id }
      end
      it "locates requested driver to @driver" do
        expect(assigns[:driver]).to eq(@driver)
      end
      it "renders the :edit_bid template" do
        expect(response).to render_template :edit_bid
      end
    end

    context "with logged-in and un-authorized driver" do
      before :each do
        log_in_as @another_driver
        get :edit_bid, params: { id: @driver.id }
      end
      it "redirects to the driver's profile page" do
        expect(response).to redirect_to @another_driver
      end
    end

    context "with non-logged in and un-authorized driver" do
      it "redirects to the login page" do
        get :edit_bid, params: { id: @driver.id }
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "PATCH #update_bid" do
    before :each do
      @driver = create(:driver)
      @another_driver = create(:driver)
    end

    context "with logged-in and authorized driver" do
      before :each do
        log_in_as @driver
      end
      context "with valid attributes" do
        before { patch :update_bid, params: { id: @driver.id, driver: attributes_for(:driver, bid_status: "Online") } }
        it "updates the driver's bid_status in the database" do
          @driver.reload
          expect(@driver.bid_status).to match(/Online/)
        end
        it "redirects to the driver profile page" do
          expect(response).to redirect_to @driver
        end
        it "shows the success flash message" do
          expect(flash[:success]).to match(/Your bid status was successfully updated./)
        end
      end
      context "with invalid attributes" do
        before { patch :update_bid, params: { id: @driver.id, driver: attributes_for(:invalid_driver, bid_status: "Online") } }
        it "does not update the driver's bid status in the database" do
          @driver.reload
          expect(@driver.bid_status).not_to match(/Dude/)
        end
        it "has validation errors message" do
          expect(assigns[:driver].errors.count).not_to eq(0)
        end
        it "re-renders the :edit_bid template" do
          expect(response).to render_template :edit_bid
        end
      end
    end
    context "with logged-in and un-authorized driver" do
      before :each do
        log_in_as @another_driver
        patch :update_bid, params: { id: @driver.id, driver: attributes_for(:driver, bid_status: "Online") }
      end
      it "redirects to that driver's profile page" do
        expect(response).to redirect_to @another_driver
      end
    end
    context "with non-logged in and un-authorized driver" do
      it "redirects to the login page" do
        patch :update_bid, params: { id: @driver.id, driver: attributes_for(:driver, bid_status: "Online") }
        expect(response).to redirect_to login_path
      end
    end
  end
end
