FactoryBot.define do
  factory :driver do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password "whatapassword"
    password_confirmation "whatapassword"
    sequence(:phone) { |n| "0812225556#{n}" }
    go_service "Go-Ride"
    bid_status "Offline"
    gopay_balance 0.0
  end

  factory :invalid_driver, parent: :driver do
    name nil
    email nil
    password nil
    password_confirmation nil
    phone nil
    go_service nil
    bid_status nil
  end
end
