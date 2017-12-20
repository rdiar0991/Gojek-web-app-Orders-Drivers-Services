class FindDriverJob < ApplicationJob
  queue_as :default

  def perform(order)
    picked_driver_id = nil
    sleep(10)   # Delay for simulation

    origin_coordinates = gmaps_geocode(order.origin)

    online_drivers = fetch_online_drivers(order.service_type)

    unless online_drivers.nil?
      formatted_online_drivers = format_online_drivers_to_hash(online_drivers)
      drivers_around_user = drivers_around(formatted_online_drivers, origin_coordinates)
      picked_driver_id = get_driver_by_last_job_date(drivers_around_user) unless (drivers_around_user.nil? || drivers_around_user.empty?)
    end

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
