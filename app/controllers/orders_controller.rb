class OrdersController < ApplicationController
  before_action :order_params, only: [:create, :commit_order]
  before_action :ensure_order_params_is_present, only: [:confirm_order]


  def new
    if logged_in?
      @order = Order.new
    else
      flash[:danger] = "Please log in to continue"
      redirect_to login_path
    end
  end

  def create
    @order = Order.new(order_params)
    @order.user_id = session[:user_id]
    distance_matrix = google_distance_matrix(@order)
    @order.distance = gmaps_distance(distance_matrix)
    @order.price = est_price(@order)
    @order.status = "Looking for driver"
    if logged_in? && @order.valid?
      render :confirm_order
    else
      render :new
    end
  end

  def confirm_order
    # @order.new(order_params)
  end

  def commit_order
    @order = Order.new(order_params)
    @order.status = "Looking for driver"
    @order.user_id = session[:user_id]

    # Todo: Implement to ActiveJob
    @origin_coordinates = gmaps_geocode(@order.origin)
    @online_drivers = fetch_online_drivers(@order.service_type)
    @driver_around_users = drivers_around(@online_drivers, @origin_coordinates)
    @picked_driver_id = lucky_driver(@driver_around_users)   # ntar ganti
    @picked_driver = Driver.find_by(id: @picked_driver_id)
    @order.driver_id = @picked_driver.id
    @picked_driver.bid_status = "Busy"
    @order.status = "On the way"

    if @order.payment_type == "GoPay"
      @user = User.find_by(id: @order.user_id)
      @user.gopay_balance -= @order.price
      @user.save
      @picked_driver.gopay_balance += @order.price
    end
    # end of ActiveJob

    if @order.save && @picked_driver.save
      flash[:success] = "Finding the nearest driver, please wait."
      redirect_to current_order_path(current_user)
    else
      flash[:danger] = "Whoops! Something, went wrong. #{@order.errors.messages}"
      redirect_to new_order_path
    end
  end

  private

  def order_params
    params.require(:order).permit(:origin, :destination, :payment_type, :service_type, :price, :distance)
  end

  def ensure_order_params_is_present
    redirect_to new_order_path if params[:order].nil?
  end
end
