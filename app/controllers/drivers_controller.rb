class DriversController < ApplicationController
  before_action :logged_in_driver, only: [:show, :edit, :update, :edit_location, :update_location, :edit_bid, :update_bid, :current_job, :update_current_job]
  before_action :correct_driver, only: [:show, :edit, :update, :edit_location, :update_location, :edit_bid, :update_bid, :current_job, :update_current_job]
  before_action :set_driver, only: [:show, :edit, :update, :edit_location, :update_location, :edit_bid, :update_bid, :current_job, :update_current_job]
  before_action :driver_params, only: [:create, :update, :update_location, :update_bid]
  before_action :set_current_job, only: [:current_job, :update_current_job]
  before_action :ensure_params_contains_complete, only: [:update_current_job]

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
    if @driver.update_attributes(driver_params)
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
    if @job.save
      flash[:success] = "Your job has successfully marked as 'Complete'. Thank you."
      redirect_to current_job_path
    else
      flash[:danger] = "We are sorry, something went wrong while updating your job status."
      redirect_to current_job_path
    end

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

end
