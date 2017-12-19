class OrderSerializer < ActiveModel::Serializer
  belongs_to :user
  belongs_to :driver, optional: true

  attributes :id, :origin, :destination, :distance, :payment_type, :status, :user_id, :driver_id, :price, :service_type
end
