module OrdersHelper
  GO_RIDE_PRICE_PER_KM = 1_500.0
  GO_CAR_PRICE_PER_KM = 2_500.0
  MAX_TRIP_DISTANCE_IN_KM = 20.0
  MAX_DRIVER_DISTANCE_FROM_USER_IN_METER = 2_500.0

  def google_distance_matrix(origin, destination, gmaps=gmaps_service)
    gmaps.distance_matrix(origin, destination, mode: 'driving')
  end

  def gmaps_distance(distance_matrix)
    return nil if distance_matrix.nil?
    distance_in_meter = distance_matrix[:rows][0][:elements][0][:distance][:value]
    distance_in_km = (distance_in_meter/1_000.0).round(1)
  end

  def est_price(order)
    if order.service_type == 'Go-Ride'
      order.distance > 1.0 ? GO_RIDE_PRICE_PER_KM * order.distance : GO_RIDE_PRICE_PER_KM
    else
      order.distance > 1.0 ? GO_CAR_PRICE_PER_KM * order.distance : GO_CAR_PRICE_PER_KM
    end
  end

  def distance_is_greater_than_max?(order)
    return nil if order.distance.nil?
    order.distance > MAX_TRIP_DISTANCE_IN_KM
  end

  def gmaps_geocode(location)
    reutn nil if location.nil?
    gmaps = gmaps_service
    geocode_results = gmaps.geocode(location)
    location_coordinates = Array.new
    geocode_results[0][:geometry][:location].each_value { |coords| location_coordinates << coords }
    location_coordinates
  end

  def fetch_online_drivers(service_type)
    online_drivers = Driver.where(go_service: service_type).where(bid_status: "Online").where("current_coord != 'N/A'")
    online_drivers.empty? ? nil : online_drivers
  end

  def format_online_drivers_to_hash(online_drivers)
    return nil if online_drivers.nil?

    formatted_online_drivers = {}
    online_drivers.each { |driver| formatted_online_drivers[driver.id] = { coords: driver.current_coord.split(", ").map { |c| c.to_f }, last_job_date: driver.orders.empty? ? nil : driver.orders.last.created_at } }
    formatted_online_drivers
  end

  def drivers_around(formatted_online_drivers, origin)
    return nil if formatted_online_drivers.nil? || origin.nil?
    nearer_drivers = {}

    formatted_online_drivers.each do |driver_id, attributes|
      driver_distance_from_origin = haversine_formula(origin, attributes[:coords])
      nearer_drivers[driver_id] = { distance: driver_distance_from_origin, last_job_date: attributes[:last_job_date] } if driver_distance_from_origin <= MAX_DRIVER_DISTANCE_FROM_USER_IN_METER
    end
    nearer_drivers
  end

  def haversine_formula(loc1, loc2)
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
    dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    rm * c # Delta in meters
  end

  def get_driver_by_last_job_date(drivers)
    picked_driver_id = nil
    id_date_hsh = {}
    drivers.each do |id, attributes|
      if attributes[:last_job_date].nil?
        return id
      else
        id_date_hsh[id] = attributes[:last_job_date]
      end
    end
    id_date_hsh.sort_by { |id, date| date }.first.first
  end

  def get_lucky_driver(drivers)
    driver.keys.sample
  end

  private

  def gmaps_service
    GoogleMapsService::Client.new(key: 'AIzaSyAT3fcxh_TKujSW6d6fP9cUtrexk0eEvAE')
  end
end
