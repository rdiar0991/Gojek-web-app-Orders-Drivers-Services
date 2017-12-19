class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # include ActionController::Serialization
  include SessionsHelper
  include OrdersHelper
  include Response
  include ExceptionHandler
end
