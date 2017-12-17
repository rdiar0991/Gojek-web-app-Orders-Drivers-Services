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
          patch :update_location, params: { id: @driver.id, driver: attributes_for(:driver, current_location: "Sarinah, Jakarta", bid_status: "Online") }
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
          patch :update_location, params: { id: @driver.id, driver: attributes_for(:driver, current_location: "Lokasi yang tak diriundukan...Lul", bid_status: "Online") }
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

    context "while driver has an active job" do
      before :each do
        @user = create(:user)
        @order = create(:order, user_id: @user.id, driver_id: @driver.id, status: "On the way")
        log_in_as @driver
        get :edit_bid, params: { id: @driver.id }
      end
      it "redirects to the current_job_path" do
        expect(response).to redirect_to current_job_path(@driver)
      end
      it "sets flash[:danger] message" do
        expect(flash[:danger]).to match(/You can't edit your bid status while you have an active job./)
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
        before { patch :update_bid, params: { id: @driver.id, driver: attributes_for(:driver, bid_status: "Online", current_location: "Monas, Jakarta") } }
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
        before { patch :update_bid, params: { id: @driver.id, driver: attributes_for(:invalid_driver, bid_status: "Online", current_location: "") } }
        it "does not update the driver's bid status in the database" do
          @driver.reload
          expect(@driver.bid_status).not_to match(/Online/)
        end
        it "has validation errors message" do
          expect(assigns[:driver].errors.count).not_to eq(0)
        end
        it "re-renders the :edit_bid template" do
          expect(response).to render_template :edit_bid
        end
      end

      context "with bid status sets to Offline" do
        before :each do
          @driver.bid_status = "Online"
          @driver.current_location = "Sarinah, Jakarta"
          @driver.save
          patch :update_bid, params: { id: @driver.id, driver: attributes_for(:driver, bid_status: "Offline", current_location: "Sarinah, Jakarta") }
        end
        it "updates the bid status equals 'Offline'" do
          @driver.reload
          expect(@driver.bid_status).to match(/Offline/)
        end
        it "re-set the driver's current location to nil" do
          @driver.reload
          expect(@driver.current_location).to eq(nil)
        end
        it "re-set the driver's current coordinates to nil" do
          @driver.reload
          expect(@driver.current_coord).to eq(nil)
        end
        it "redirects to the profile page" do
          expect(response).to redirect_to @driver
        end
      end

      context "with bid status sets to Online" do
        before :each do
          @driver.bid_status = "Offline"
          @driver.save
        end

        it "updates the driver's bid status to 'Online'" do
          patch :update_bid, params: { id: @driver.id, driver: attributes_for(:driver, bid_status: "Online", current_location: "Sarinah, Jakarta") }
          @driver.reload
          expect(@driver.bid_status).to match(/Online/)
        end
        it "does not updates the attributes if location is invalid" do
          patch :update_bid, params: { id: @driver.id, driver: attributes_for(:driver, bid_status: "Online", current_location: "") }
          @driver.reload
          expect(@driver.bid_status).not_to match(/Online/)
          expect(@driver.current_location).not_to match(//)
        end
        it "re-renders the :update_bid template" do
          patch :update_bid, params: { id: @driver.id, driver: attributes_for(:driver, bid_status: "Online", current_location: "") }
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

  describe "GET #current_job" do
    before :each do
      @user = create(:user)
      @driver = create(:driver)
      @job = create(:order, user_id: @user.id, driver_id: @driver.id)
      log_in_as @driver
      get :current_job, params: { id: @driver.id }
    end
    it "assigns driver to @driver" do
      expect(assigns[:driver]).to eq(@driver)
    end
    it "assigns name of user to @name_of_user" do
      expect(assigns[:name_of_user]).to eq(@user.name)
    end
    it "assigns the in-complete to @job" do
      expect(assigns[:job].status).to match(/On the way/)
    end
    it "renders the :current_job template" do
      expect(response).to render_template :current_job
    end
  end

  describe "PATCH #update_current_job_path" do
    before :each do
      @user = create(:user)
      @driver = create(:driver)
      log_in_as @driver
      @job = create(:order, user_id: @user.id, driver_id: @driver.id)
    end

    context "with valid attributes" do
      before :each do
        patch :update_current_job, params: { id: @driver.id, order: {status: 'Complete'} }
      end
      it "updates the job's status as 'Complete'" do
        @job.reload
        expect(@job.status).to match(/Complete/)
      end
      it "redirects to the :current_job template" do
        expect(response).to redirect_to current_job_path(@driver)
      end
    end

    context "with param status not equals 'Complete'" do
      before :each do
        patch :update_current_job, params: { id: @driver.id, order: {status: 'On the way'} }
      end
      it "does not updates the job status in the database" do
        @job.reload
        expect(@job.status).not_to match(/Complete/)
      end
      it "redirects to the :current_job template" do
        expect(response).to redirect_to current_job_path(@driver)
      end
    end
  end

  describe "GET #jobs_history" do
    before :each do
      @user = create(:user)
      @another_user = create(:user)
      @driver = create(:driver)
      @another_driver = create(:driver)
      @job1 = create(:order, user_id: @user.id, status: "Complete", driver_id: @driver.id)
      @job2 = create(:order, user_id: @user.id, status: "Complete", driver_id: @driver.id)
      @job3 = create(:order, user_id: @user.id, driver_id: @driver.id)
      @job4 = create(:order, user_id: @another_user.id, status: "Complete", driver_id: @another_driver.id)
    end

    context "with authorized driver" do
      before :each do
        log_in_as @driver
        get :jobs_history, params: { id: @driver.id }
      end
      it "collects all Complete jobs to @completed_driver_jobs" do
        expect(assigns[:completed_driver_jobs]).to match_array([@job1, @job2])
      end
      it "renders the :jobs_history template" do
        expect(response).to render_template :jobs_history
      end
    end

    context "with unauthorized user" do
      before :each do
        log_in_as @another_driver
        get :jobs_history, params: { id: @driver.id }
      end
      it "redirects to the profile page" do
        expect(response).to redirect_to @another_driver
      end
    end
  end

end
