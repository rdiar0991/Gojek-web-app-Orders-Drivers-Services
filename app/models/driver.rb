class Driver < ApplicationRecord
  has_many :orders, dependent: :destroy

  before_validation :ensure_location_has_coordinates, if: :current_location_changed? || :driver_is_online?
  before_save :downcase_email
  before_update :reset_location_and_coordinates, unless: :driver_is_online?

  has_secure_password

  enum go_service: {
    "Go-Ride" => 0,
    "Go-Car" => 1
  }

  enum bid_status: {
    "Offline" => 0,
    "Online" => 1,
    "Busy" => 2
  }

  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
  validates :name, presence: true, length: { maximum: 51 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validates :phone, presence: true, length: { minimum: 11, maximum: 13 }, uniqueness: true, numericality: true
  validates :go_service, presence: true
  validates :gopay_balance, presence: true, numericality: { greater_than_or_equal_to: 0.0 }, on: :update, if: :gopay_balance_changed?
  validates :go_service, inclusion: go_services.keys, presence: true
  validates :current_location, presence: true, on: :update, if: (:bid_status_changed? || :driver_is_online?)
  validates :current_coord, presence: true, on: :update, if: (:bid_status_changed? || :driver_is_online?)
  validates :bid_status, inclusion: bid_statuses.keys, presence: true, on: :update, if: :bid_status_changed?


  private

    def downcase_email
      self.email = email.downcase if !email.nil?
    end

    def set_current_coordinates
      self.current_coord = fetch_coordinates(google_geocode)
    end

    def google_geocode
      return nil if current_location.nil? || current_location.empty?
      gmaps = GoogleMapsService::Client.new(key: 'AIzaSyAT3fcxh_TKujSW6d6fP9cUtrexk0eEvAE')
      geocode_results = gmaps.geocode(current_location)
      if geocode_results.empty? || geocode_results.length == 0
        return nil
      end
      geocode_results
    end

    def fetch_address(geocode_results)
      geocode_results.nil? ? nil : geocode_results[0][:formatted_address]
    end

    def fetch_coordinates(geocode_results)
      geocode_results.nil? ? nil : geocode_results[0][:geometry][:location].values.join(", ")
    end

    def ensure_location_has_coordinates
      errors.add(:current_coord, "is not found.") unless set_current_coordinates
    end

    def driver_is_online?
      self.bid_status == "Online"
    end

    def reset_location_and_coordinates
      self.current_location = nil
      self.current_coord = nil
    end

end
