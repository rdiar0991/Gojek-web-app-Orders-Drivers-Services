require "google_maps_service"
module LocationFinder
  def get_coord(location)
    return nil if location.nil? || location.empty?
    gmaps = GoogleMapsService::Client.new(key: 'AIzaSyAT3fcxh_TKujSW6d6fP9cUtrexk0eEvAE')
    results = gmaps.geocode(location)
    if results.empty? || results.length == 0
      return nil
    else
      results = results[0][:geometry][:location].values.join(', ')
    end
  end

end
