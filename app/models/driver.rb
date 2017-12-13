class Driver < ApplicationRecord
  before_save :downcase_email

  enum go_services: {
    "Go-Ride" => "go_ride",
    "Go-Car" => "go_car"
  }

  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true
  validates :name, presence: true, length: { maximum: 51 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validates :phone, presence: true, length: { minimum: 11, maximum: 12 }, uniqueness: true, numericality: true
  validates :go_service, presence: true
  validates :gopay_balance, presence: true, numericality: { greater_than_or_equal_to: 0.0 }, on: :update, if: :gopay_balance_changed?
  validates :go_service, inclusion: go_services.keys, presence: true, on: :update, if: :go_service_changed?

  def downcase_email
    self.email = email.downcase if !email.nil?
  end
end
