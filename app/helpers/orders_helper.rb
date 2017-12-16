module OrdersHelper
  GO_RIDE_PRICE_PER_KM = 1_500.0
  GO_CAR_PRICE_PER_KM = 2_500.0
  MAX_DRIVER_DISTANCE_FROM_USER = 2_500.0

  def google_distance_matrix(order)
    origin_address = order.origin
    destination_address = order.destination

    gmaps = gmaps_service
    distance_matrix_results = gmaps.distance_matrix(origin_address, destination_address, mode: 'driving')
  end

  def gmaps_distance(distance_matrix)
    distance_in_meter = distance_matrix[:rows][0][:elements][0][:distance][:value]
    distance_in_km = (distance_in_meter/1_000.0).round(1)
  end

  def est_price(order)
    if order.service_type == 'Go-Ride'
      return GO_RIDE_PRICE_PER_KM * order.distance
    else
      return GO_CAR_PRICE_PER_KM * order.distance
    end
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
    online_drivers_hash = {}
    online_drivers = Driver.where(go_service: service_type).where(bid_status: "Online").pluck(:id, :current_coord)
    online_drivers.each { |id, coords| online_drivers_hash[id] = coords }
    online_drivers_hash.map { |id, coord| online_drivers_hash[id] = coord.split(", ").map { |coord| coord.to_f } }
    online_drivers_hash
  end

  def drivers_around(online_drivers, origin)
    nearer_drivers = {}
    online_drivers.each do |driver_id, coords|
      driver_distance_from_origin = haversine_formula(origin, coords)
      nearer_drivers[driver_id] = driver_distance_from_origin if driver_distance_from_origin <= MAX_DRIVER_DISTANCE_FROM_USER
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

  def lucky_driver(drivers)
    drivers.keys.sample
  end

  private

  def gmaps_service
    GoogleMapsService::Client.new(key: 'AIzaSyAT3fcxh_TKujSW6d6fP9cUtrexk0eEvAE')
  end


end
