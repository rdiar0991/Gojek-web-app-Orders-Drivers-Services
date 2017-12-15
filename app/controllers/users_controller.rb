class UsersController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :topup_gopay, :update_gopay, :current_order]
  before_action :correct_user, only: [:show, :edit, :update, :topup_gopay, :update_gopay, :current_order]
  before_action :set_user, only: [:show, :edit, :update, :topup_gopay, :update_gopay]
  before_action :user_params, only: [:create, :update, :update_gopay]
  before_action :set_current_order, only: [:current_order]

  # GET /users/new
  # or
  # GET /signup
  def new
    @user = User.new
  end

  # GET /users/:id
  def show
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Go-JEK Web App!"
      redirect_to @user
    else
      render :new
    end
  end

  # GET /users/:id/edit
  def edit
  end

  # PATCH /users/:id
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      render :edit
    end
  end

  # GET /users/:id/topup
  def topup_gopay
  end

  # PATCH /users/:id/topup
  def update_gopay
    old_gopay_balance = @user.gopay_balance
    @user.gopay_balance = user_params[:gopay_balance]
    if @user.valid?
      @user.gopay_balance += old_gopay_balance
      @user.save
      flash[:success] = "Topup success."
      redirect_to @user
    else
      @user.gopay_balance = old_gopay_balance
      flash[:danger] = "Topup failed."
      render :topup_gopay
    end
  end

  # GET /users/:user_id/orders/:order_id/on-process
  def current_order
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :phone, :gopay_balance)
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in to continue."
      redirect_to login_path
    end
  end

  def correct_user
    key_find_id = params[:id].nil? ? params[:user_id] : params[:id]
    @user = User.find(key_find_id)
    redirect_to current_user unless current_user?(@user)
  end

  def set_current_order
    @order = @user.orders.where("status != 'Complete'").last
    @driver_id, @driver_name = Driver.pluck(:id, :name).select { |id, name| id == @order.driver_id }.flatten
  end
end
