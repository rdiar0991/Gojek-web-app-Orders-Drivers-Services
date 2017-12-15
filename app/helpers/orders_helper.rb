module OrdersHelper
  GO_RIDE_PRICE_PER_KM = 1_500.0
  GO_CAR_PRICE_PER_KM = 2_500.0

  def google_distance_matrix(order)
    origin_address = order.origin
    destination_address = order.destination

    gmaps = GoogleMapsService::Client.new(key: 'AIzaSyAT3fcxh_TKujSW6d6fP9cUtrexk0eEvAE')
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

end
