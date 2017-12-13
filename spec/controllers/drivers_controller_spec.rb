require 'rails_helper'

RSpec.describe DriversController, type: :controller do
  describe "GET #show" do
    before :each do
      @driver = create(:driver)
      get :show, params: { id: @driver.id }
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "shows the correct driver" do
      expect(assigns[:driver]).to eq(@driver)
    end
    it "renders the :show template" do
      expect(response).to render_template(:show)
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

    context "with authorized logged-in driver" do
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

    context "non-authorized logged-in driver" do
      before :each do
        log_in_as(@another_driver)
        get :edit, params: { id: @driver.id }
      end
      it "redirects to the profile page" do
        expect(response).to redirect_to(@another_driver)
      end
    end

    context "with non-authorized and non-logged in driver" do
      it "redirects to the login page" do
        get :edit, params: { id: @driver.id }
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "PATCH #update" do
    before :each do
      @driver = create(:driver, name: "anugrah")
    end

    context "with valid attributes" do
      before :each do
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
end
