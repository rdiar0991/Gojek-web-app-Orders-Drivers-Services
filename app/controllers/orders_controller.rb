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
    @order.driver_id = Driver.find_by(id: rand(1..Driver.count)).id # Random
    @order.status = "On the way"
    @order.user_id = session[:user_id]
    if @order.save
      flash[:success] = "The driver is on the way, please wait."
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
