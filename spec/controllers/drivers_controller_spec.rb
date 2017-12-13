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
      before :each do

      end
      it "saves new driver in the database" do
        expect{
          post :create, params: { driver: attributes_for(:driver) }
        }.to change(Driver, :count).by(1)
      end

      pending "sets a new session for driver login automatically"

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
end
