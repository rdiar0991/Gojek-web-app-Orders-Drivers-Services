FactoryBot.define do
  factory :driver do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password "whatapassword"
    password_confirmation "whatapassword"
    sequence(:phone) { |n| "0812225556#{n}" }
    go_service "go-ride"
  end

  factory :invalid_driver, parent: :driver do
    name nil
    email nil
    password "short"
    password_confirmation "short"
    phone nil
    go_service nil
  end
end
