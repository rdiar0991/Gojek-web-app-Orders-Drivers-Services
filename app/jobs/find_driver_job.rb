class FindDriverJob < ApplicationJob
  queue_as :default

  def perform(order)
    sleep(10)   # Biar kerasa ada delay

    origin_coordinates = gmaps_geocode(order.origin)
    online_drivers = fetch_online_drivers(order.service_type)
    driver_around_users = drivers_around(online_drivers, origin_coordinates)
    picked_driver_id = lucky_driver(driver_around_users)   # ntar ganti
    if picked_driver_id.nil?
      order.status = "Driver not found"
      order.save
      return nil
    end
      picked_driver = Driver.find_by(id: picked_driver_id)
      order.driver_id = picked_driver.id
      picked_driver.bid_status = "Busy"
      order.status = "On the way"

    if order.payment_type == "GoPay"
      user = User.find_by(id: order.user_id)
      user.gopay_balance -= order.price
      user.save
      picked_driver.gopay_balance += order.price
    end
    picked_driver.save
    order.save
  end
end
