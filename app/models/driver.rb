class Driver < ApplicationRecord

  before_save :downcase_email
  before_validation :ensure_location_has_coordinates, if: :current_location_changed?

  has_secure_password

  enum go_services: {
    "Go-Ride" => "go_ride",
    "Go-Car" => "go_car"
  }

  enum bid_statuses: {
    "Online" => "online",
    "Busy" => "busy"
  }

  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
  validates :name, presence: true, length: { maximum: 51 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validates :phone, presence: true, length: { minimum: 11, maximum: 13 }, uniqueness: true, numericality: true
  validates :go_service, presence: true
  validates :gopay_balance, presence: true, numericality: { greater_than_or_equal_to: 0.0 }, on: :update, if: :gopay_balance_changed?
  validates :go_service, inclusion: go_services.keys, presence: true
  validates :current_location, presence: true, on: :update, if: :current_location_changed?
  validates :current_coord, presence: true, on: :update, if: :current_coord_changed?
  validates :bid_status, inclusion: bid_statuses.keys, presence: true, on: :update, if: :bid_status_changed?

  def downcase_email
    self.email = email.downcase if !email.nil?
  end

  def set_current_coordinates
    geocode_results = location_coordinates
    self.current_location += " (#{geocode_results[0]})"
    self.current_coord = geocode_results[1]
  end

  def location_coordinates
    return nil if current_location.nil? || current_location.empty?
    gmaps = GoogleMapsService::Client.new(key: 'AIzaSyAT3fcxh_TKujSW6d6fP9cUtrexk0eEvAE')
    geocode_results = gmaps.geocode(current_location)
    if geocode_results.empty? || geocode_results.length == 0
      return nil
    else
      coord_result = geocode_results[0][:geometry][:location].values.join(', ')
      address_result = geocode_results[0][:formatted_address]
      filtered_results = [address_result, coord_result]
    end
  end

  def ensure_location_has_coordinates
    if location_coordinates
      set_current_coordinates
    else
      errors.add(:current_coord, "is not found.")
    end
  end
end
