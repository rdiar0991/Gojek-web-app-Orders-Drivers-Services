FactoryBot.define do
  factory :order do
    origin { Faker::Address.street_address }
    destination { Faker::Address.street_address }
    distance 6
    payment_type "Cash"
    status "Complete"
    price 12000.0
    user_id nil
    driver_id nil
  end

  factory :invalid_order, parent: :order do
    origin { Faker::Address.street_address }
    destination { Faker::Address.street_address }
    distance 6
    payment_type "Cash"
    status "Complete"
    price nil
    user_id nil
    driver_id nil
  end
end
