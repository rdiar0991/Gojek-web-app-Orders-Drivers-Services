class NewUserConsumer < Racecar::Consumer
  subscribes_to "new-user-profile"

  def process(message)
    puts "Received message: #{message.value}"
    user_attributes = JSON.parse(message.value)
    user = User.new(user_attributes)
    if user.save
      puts "New user was succesfully created."
    else
      puts user.errors.messages
    end
  end
end
