class OrdersController < ApplicationController
  before_action :order_params, only: [:create, :commit_order]
  before_action :ensure_order_params_is_present, only: [:confirm_order]
  before_action :redirect_if_user_already_have_active_order, only: [:new]

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
    if logged_in? && @order.valid? && ensure_gopay_balance_is_sufficient
      render :confirm_order
    else
      render :new
    end
  end

  def confirm_order
  end

  def commit_order
    @order = Order.new(order_params)
    @order.user_id = current_user.id
    @order.status = "Looking for driver"


    if @order.save
      FindDriverJob.perform_later(@order)

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

  def ensure_gopay_balance_is_sufficient
    if @order.payment_type == "GoPay" && current_user.gopay_balance < @order.price
      flash.now[:danger] = "Whoops, your gopay balance is not suffiecient. Try another payment type."
      return false
    else
      return true
    end
  end

  def redirect_if_user_already_have_active_order
    if current_user.orders.where("status == 2 OR status == 0").any?
      flash[:danger] = "You already have an active order, can't create new one."
      redirect_to current_order_path(current_user) and return
    end
  end
end
