class Api::V1::OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :params_for_new_order, only: [:new]
  before_action :set_user, only: [:new]

  def index
    if params[:user_id]
      @user = User.find(params[:user_id])
      @orders = @user.orders.order(created_at: :desc)
      respond_to do |format|
        format.json { render json: @orders, status: :ok }
      end
    else
      head :no_content
    end

  end

  def new
    error_messages = {}
    @order = Order.new(params_for_new_order)

    @order.distance = gmaps_distance(ensure_locations_can_be_calculated(@order.origin, @order.destination))
    if @order.distance.nil?
      error_messages[:distance] = "Origin or destination location is not found."
    else
      @order.price = est_price(@order)
      error_messages[:gopay_balance] = "Your gopay balance is not suffiecient." if is_gopay?(@order.payment_type) && insufficient_gopay_balance?(@user, @order.price)
    end

    error_messages[:distance] = "Trip distance is too far (maximum is 20 km)." if distance_is_greater_than_max?(@order)
    
    respond_to do |format|
      if error_messages.none?
        format.json { render json: @order, status: :ok  }
      else
        format.json { render json: error_messages.to_json, status: :ok }
      end
    end
  end

  def show
    if params[:user_id]
      @user = User.find(params[:user_id])
      @order = @user.orders.last
      @order = nil if @order.status == 'Complete'
      respond_to do |format|
        format.json { render json: @order, status: :ok }
      end
    else
      head :no_content
    end
  end

  def create
    @order = Order.new(params_for_new_order)
    @order.status = "Looking for driver"

    respond_to do |format|
      if @order.save
        FindDriverJob.perform_later(@order)
        format.json { render json: @order, status: :created  }
      else
        format.json { render json: @order, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def params_for_new_order
    params.permit(:origin, :destination, :payment_type, :service_type, :user_id, :price, :distance)
  end

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

  def ensure_locations_can_be_calculated(origin=order_params[:origin], destination=order_params[:destination])
    return nil if (origin.empty? || destination.empty?)
    @distance_matrix = google_distance_matrix(origin, destination)
    if @distance_matrix[:rows][0][:elements][0][:status] == "NOT_FOUND"
      @order.distance = nil
    else
      @distance_matrix
    end

  end
end
