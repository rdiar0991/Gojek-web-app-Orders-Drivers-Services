class Order < ApplicationRecord
  belongs_to :user
  belongs_to :driver, optional: true

  enum payment_type: {
    "Cash" => 0,
    "GoPay" => 1
  }

  enum status: {
    "Looking for driver" => 0,
    "Driver is on the way" => 1,
    "On the way" => 2,
    "Complete" => 3
  }

  validates :origin, presence: true
  validates :destination, presence: true
  validates :distance, numericality: true
  validates :price, numericality: true
  validates :payment_type, inclusion: payment_types.keys, presence: true
  validates :service_type, inclusion: Driver.go_services.keys, presence: true
  validates :status, inclusion: statuses.keys
end
