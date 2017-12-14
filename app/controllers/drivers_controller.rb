class DriversController < ApplicationController
  before_action :logged_in_driver, only: [:show, :edit, :update, :edit_location, :update_location]
  before_action :correct_driver, only: [:show, :edit, :update, :edit_location, :update_location]
  before_action :set_driver, only: [:show, :edit, :update, :edit_location, :update_location]
  before_action :driver_params, only: [:create, :update, :update_location]

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
end
