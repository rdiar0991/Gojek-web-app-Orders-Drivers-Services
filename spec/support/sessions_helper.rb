module SessionsHelpers

  def log_in_as(user)
    session[:user_id] = user.id
    session[:role] = user.class.name.downcase
  end
end

RSpec.configure do |c|
  c.include SessionsHelpers
end
