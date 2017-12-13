class DriversController < ApplicationController
  before_action :set_driver, only: [:show]
  before_action :driver_params, only: [:create]

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

  private

  def set_driver
    @driver = Driver.find(params[:id])
  end

  def driver_params
    params.require(:driver).permit(:name, :email, :phone, :password, :password_confirmation, :go_service)
  end
end
