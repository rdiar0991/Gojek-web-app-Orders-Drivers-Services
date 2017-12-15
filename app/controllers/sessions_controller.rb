class SessionsController < ApplicationController
  def new
    redirect_back_or root_path if logged_in?
  end

  def create
    person = params[:session][:role].classify.constantize.find_by(email: params[:session][:email].downcase)
    if person && person.authenticate(params[:session][:password])
    log_in person
    redirect_back_or person
    else
      flash.now[:danger] = "Invalid email/password combination."
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
