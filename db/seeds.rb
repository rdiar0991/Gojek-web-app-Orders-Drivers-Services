# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
go_services = ["Go-Ride", "Go-Car"]
1.upto(10) do |i|
  Driver.create(name: Faker::Name.name, email:"driver_#{i}@example.com", phone:"08123456789#{i}", password:"12345678", password_confirmation:"12345678", go_service:go_services[rand(2)])
  User.create(name: Faker::Name.name, email:"user_#{i}@example.com", phone:"0897777778#{i}", password:"12345678", password_confirmation:"12345678")
end
