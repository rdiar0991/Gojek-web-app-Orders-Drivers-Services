FactoryBot.define do
  factory :order do
    origin "Wisma Naelah"
    destination "Kolla Space Sabang"
    distance 6
    payment_type "Cash"
    status "On the way"
    price 12000.0
    service_type "Go-Ride"
  end

  factory :invalid_order, parent: :order do
    origin "Wisma Naelah"
    destination "Kolla Space Sabang"
    distance nil
    payment_type nil
    status nil
    service_type nil
    price nil
    user_id nil
    driver_id nil
  end
end
