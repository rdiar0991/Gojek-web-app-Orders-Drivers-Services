class DriversController < ApplicationController
  before_action :logged_in_driver, only: [:show, :edit, :update, :edit_location, :update_location, :edit_bid, :update_bid, :current_job, :update_current_job, :jobs_history]
  before_action :correct_driver, only: [:show, :edit, :update, :edit_location, :update_location, :edit_bid, :update_bid, :current_job, :update_current_job, :jobs_history]
  before_action :set_driver, only: [:show, :edit, :update, :edit_location, :update_location, :edit_bid, :update_bid, :current_job, :update_current_job, :jobs_history]
  before_action :driver_params, only: [:create, :update, :update_location, :update_bid]
  before_action :set_current_job, only: [:current_job, :update_current_job]
  before_action :ensure_params_contains_complete, only: [:update_current_job]
  before_action :redirect_if_driver_already_have_active_job, only: [:edit_bid, :update_bid]

  def new
    @driver = Driver.new
  end

  def create
    @driver = Driver.new(driver_params)
    if @driver.save
      log_in @driver
      flash[:success] = "Welcome to the Go-JEK Web App."
      redirect_to @driver
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @driver.update_attributes(driver_params)
      flash[:success] = "Profile updated."
      redirect_to @driver
    else
      render :edit
    end
  end

  def edit_location
  end

  def update_location
    if @driver.update_attributes(driver_params)
      flash[:success] = "Your location was successfully updated."
      redirect_to @driver
    else
      @driver.reload
      render :edit_location
    end
  end

  def edit_bid
  end

  def update_bid
    @driver.bid_status = driver_params[:bid_status]
    @driver.current_location = driver_params[:current_location] if driver_params[:bid_status] == "Online"
    if @driver.save
      flash[:success] = "Your bid status was successfully updated."
      redirect_to @driver
    else
      @driver.reload
      render :edit_bid
    end
  end

  def current_job
  end

  def update_current_job
    @job.status = params[:order][:status]
    @driver = Driver.find_by(id: @job.driver_id)
    @driver.bid_status = "Online"
    @driver.current_location = @job.destination
    @driver.current_coord = gmaps_geocode(@job.destination).join(", ")

    if @job.save && @driver.save
      flash[:success] = "Your job has successfully marked as 'Complete'. Thank you."
      redirect_to current_job_path
    else
      flash[:danger] = "We are sorry, something went wrong while updating your job status."
      redirect_to current_job_path
    end

  end

  def jobs_history
    @completed_driver_jobs = Order.joins(:driver, :user).where(driver_id: @driver.id).where(status: "Complete")
  end

  private

  def set_driver
    @driver = Driver.find(params[:id])
  end

  def driver_params
    params.require(:driver).permit(:name, :email, :phone, :password, :password_confirmation, :go_service, :current_location, :bid_status)
  end

  def logged_in_driver
    unless logged_in?
      store_location
      flash[:danger] = "Please log in to continue."
      redirect_to login_path
    end
  end

  def correct_driver
    @driver = Driver.find(params[:id])
    redirect_to current_user unless current_user?(@driver)
  end

  def set_current_job
    @job = @driver.orders.find_by(status: "On the way")
    @user_id, @name_of_user = User.pluck(:id, :name).select { |id, name| id == @job.user_id }.flatten unless @job.nil?
  end

  def ensure_params_contains_complete
    redirect_to current_job_path(@driver) unless params[:order][:status] == "Complete"
  end

  def redirect_if_driver_already_have_active_job
    if current_user.orders.where("status == 2 OR status == 0").any?
      flash[:danger] = "You can't edit your bid status while you have an active job."
      redirect_to current_job_path(current_user) and return
    end
  end

end
