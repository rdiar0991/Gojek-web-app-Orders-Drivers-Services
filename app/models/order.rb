class Order < ApplicationRecord
  belongs_to :user
  belongs_to :driver, optional: true

  enum payment_types: {
    "Cash" => "Cash",
    "GoPay" => "GoPay"
  }

  enum order_statuses: {
    "Looking for driver" => "waiting",
    "On the way" => "otw",
    "Complete" => "complete"
  }

  validates :origin, presence: true
  validates :destination, presence: true
  validates :distance, numericality: true
  validates :price, numericality: true
  validates :payment_type, inclusion: payment_types.keys, presence: true
  validates :service_type, inclusion: Driver.go_services.keys, presence: true
  validates :status, inclusion: order_statuses.keys
end
